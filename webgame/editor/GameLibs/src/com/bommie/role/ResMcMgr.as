package com.bommie.role
{
	import com.bommie.def.RenderActDefaultTime;
	import com.bommie.def.ResDef;
	import com.bommie.load.ResTool;
	import com.bommie.mgr.FrameMgr;
	import com.bommie.pool.RoleBMDPool;
	import com.bommie.role.struct.BitmapInfo;
	import com.bommie.utils.PathUtil;
	
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import starling.textures.Texture;

	/**
	 * mc资源管理，包括如下功能
	 * <br/>----1.切帧速度控制
	 * <br/>----2.加载完自动更新
	 * <br/>----3.索引计数
	 * <br/>----4.自动回收
	 **/
	public final class ResMcMgr
	{
		private const CUT_FRAMES:uint=5;
		public var leadRoleSkin:Array;
		private var frameTime:Number=33.33;
		private var FrameTimeOffset:int=0;
		private var leadRole:ResMc;
		private var _cutList:Vector.<Array>=new <Array>[];
		private var _stage:Stage;
		private static var _instance:ResMcMgr;

		public static function get instance():ResMcMgr
		{
			if (_instance == null)
				_instance=new ResMcMgr();
			return _instance;
		}

		public function init(stage:Stage):void
		{
			_stage=stage;
			frameTime=Number(Number(1000 / _stage.frameRate).toFixed(2)); //针对原有的技能特效配置固定30帧，这样能保证动画实际播放帧频或时间的统一
		}

		public function render():void
		{
			var ary:Array=null;
			//一帧切5张图，差不多是一个形象的基本要素
			var info:BitmapInfo=null;
			var li:int=_cutList.length - CUT_FRAMES;
			var cls:Class;
			for (var i:int=_cutList.length - 1; i > -1 && i > li; i--)
			{
				ary=_cutList.shift();
				info=ary[0];
				if (info.isDestroyed)
					continue; //被销毁了就不用再切了
				cls=ResTool.getCls(ary[1], ary[2]);
				info.texture=Texture.fromBitmapData(new cls());
				ary.length=0;
				ary=null;
//				info.bitmapData=ResTool.getBmd(ary[1], ary[2]);
			}
			if (leadRoleSkin != null)
			{
				leadRole=leadRoleSkin[2];
				if (leadRole != null)
					romance(leadRole, true);
			}
			if (RoleBMDPool.instance._runList.length > 0)
			{
				var index:int=0;
				var movie:ResMc;
				while (index < RoleBMDPool.instance._runList.length)
				{
					movie=RoleBMDPool.instance._runList[index];
					if (leadRole != movie)
						romance(movie);
					index++;
				}
			}
		}

		public function getByXml(xmlUrl:String):ResMc
		{
			var mcName:String=PathUtil.getFileName(xmlUrl);
			mcName=mcName.replace("xml", "");
			if (RoleBMDPool.instance._mcDic[xmlUrl] == null)
			{
				decode(xmlUrl);
			}
			var mc:ResMc=new ResMc();
			mc._undisposed_=true; //重新启用
			mc.mcName=mcName;
			mc.xmlPath=xmlUrl;
			mc.movie=RoleBMDPool.instance._mcDic[xmlUrl];
			if (xmlUrl.indexOf("Effect") >= 0)
			{
				mc.fpsTime=getTimer();
				mc.isPart=true;
				mc.isEffect=true;
			}
			else
				mc.fpsTime=getTimer() + (Math.random() * 500 >> 0);
			if (RoleBMDPool.instance.COUNT_DIC[mc.mcName] == null)
			{
				RoleBMDPool.instance.COUNT_DIC[mc.mcName]=0;
			}
			RoleBMDPool.instance.COUNT_DIC[mc.mcName]++;
			return mc;
		}

		public function release(mc:ResMc):void
		{
			if (mc && mc.mcName && RoleBMDPool.instance.COUNT_DIC[mc.mcName])
				RoleBMDPool.instance.COUNT_DIC[mc.mcName]--;
		}

		public function play(mc:Object):void
		{
			if (mc is ResMc)
			{
				if (RoleBMDPool.instance._runList.indexOf(mc) < 0)
					RoleBMDPool.instance._runList.push(mc);
			}
		}

		public function stop(mc:Object):void
		{
			var m_index:int;
			if (mc is ResMc)
			{
				m_index=RoleBMDPool.instance._runList.indexOf(mc);
				if (RoleBMDPool.instance._runList.indexOf(mc) >= 0)
					RoleBMDPool.instance._runList.splice(m_index, 1);
			}
		}

		public function isRunning(movie:ResMc):Boolean
		{
			return RoleBMDPool.instance._runList.indexOf(movie) >= 0;
		}

		/**
		 * 判断当前动作的资源是否加载完毕
		 */
		public function isResLoadedInAct(key:String, act:String):Boolean
		{
			var result:Boolean=false;
			var totalFramesForAllActs:Dictionary=RoleBMDPool.instance._actDic[key];
			var loadedFrameCountForAllActs:Dictionary=RoleBMDPool.instance._actResLoadedDic[key];
			if (totalFramesForAllActs != null)
			{
				var totalFramesForAct:Array=totalFramesForAllActs[act];
				var loadedFrameCountForAct:int=loadedFrameCountForAllActs[act];
				if (loadedFrameCountForAct == totalFramesForAct.length)
				{
					result=true;
				}
			}
			return result;
		}

		/**
		 * 解析xml
		 */
		private function decode(xmlUrl:String):void
		{
			var xml:XML=ResTool.getXml(xmlUrl);
			if (!xml)
			{
				return;
			}
			//默认的形象，如果是技能或者坐骑则为null
			var defaultBmd:Texture=null;
			if (xmlUrl.indexOf("Effect") < 0)
			{
				defaultBmd=ResDef.defautlBody;
			}
			var infoVec:Vector.<BitmapInfo>=new <BitmapInfo>[];
			var neededActs:Vector.<String>=new <String>[];
			var tmpDic:Dictionary=new Dictionary();
			var tmpResDic:Dictionary=new Dictionary();
			var bitmapInfo:BitmapInfo=null;
			var clas:Class=null;
			var i:int=0;
			var actList:XMLList=xml.act;
			var actLen:int=actList.length();
			var act:String;
			var i1:int=0;
			var directList:XMLList=null;
			var directLen:int=0;
			var i2:int=0;
			var frameList:XMLList=null;
			var frameLen:int=0;
			var pngName:String=null;
			var m_skillPoint:Vector.<int>=null;
			while (i < actLen)
			{
				directList=actList[i].direct;
				directLen=directList.length();
				i1=0;
				m_skillPoint=new <int>[];
				if (actList[i].@m == "3")
				{
					for (i1=0; i1 < 16; i1++)
					{
						m_skillPoint[i1]=actList[i].@["pos" + i1];
					}
					i1=0;
				}
				while (i1 < directLen)
				{
					frameList=directList[i1].frame;
					frameLen=frameList.length();
					i2=0;
					while (i2 < frameLen)
					{
						pngName=frameList[i2].@c.toString();
						bitmapInfo=getBitmapInfoByName(pngName);
						bitmapInfo.texture=defaultBmd;
						bitmapInfo.jumpFrame=actList[i].@j;
						bitmapInfo.height=directList[i1].@h;
						bitmapInfo.originX=directList[i1].@ox;
						bitmapInfo.originY=directList[i1].@oy;
						bitmapInfo.skillPoint=m_skillPoint;
						bitmapInfo.center=directList[i1].@x1
						bitmapInfo.footX=directList[i1].@x2;
						bitmapInfo.footY=directList[i1].@y2;
						bitmapInfo.wingX=directList[i1].@x3;
						bitmapInfo.wingY=directList[i1].@y3;
						bitmapInfo.direction=i1;
						infoVec.push(bitmapInfo);
						act=bitmapInfo.act;
						//保存需要加载的状态
						if (!tmpDic[act])
						{
							tmpDic[act]=[];
							tmpResDic[act]=0;
						}
						bitmapInfo.resLoadedDic=tmpResDic;
						tmpDic[act].push(pngName);
						if (neededActs.indexOf(act) < 0)
							neededActs.push(act);
						i2++;
					}
					i1++;
				}
				i++;
			}
			RoleBMDPool.instance._actDic[xmlUrl]=tmpDic;
			RoleBMDPool.instance._actResLoadedDic[xmlUrl]=tmpResDic;
			RoleBMDPool.instance._mcDic[xmlUrl]=infoVec;
			loadNeededRes(neededActs, xmlUrl.substring(0, xmlUrl.indexOf("xml")));
		}

		private function loadNeededRes(dirList:Vector.<String>, mcPreUrl:String):void
		{
			for each (var dir:String in dirList)
			{
//				ResTool.load(mcPreUrl + (dir == "D1" ? "" : dir) + ".swf", onLoadedNeededRes, null, null, null, (mcPreUrl.indexOf(Data.myKing.s2 + "") > -1 ? ResPriorityDef.SHIGH : ResPriorityDef.NORMAL));
				ResTool.load(mcPreUrl + (dir == "D1" ? "" : dir) + ".swf", onLoadedNeededRes, null, null, null);
			}
		}

		private function onLoadedNeededRes(url:String):void
		{
			var swfName:String=PathUtil.getFileName(url);
			var index:int=swfName.indexOf("D");
			//项目转换修改 var xmlUrl:String = url.substring(0, url.indexOf(".")) + "xml.xml";
			var xmlUrl:String;
			var act:String="D1";
			if (index > -1)
			{
				act=swfName.substring(index, swfName.length);
				swfName=swfName.substring(0, index);
				xmlUrl=url.substring(0, url.indexOf("D")) + "xml.xml";
			}
			else
			{
				xmlUrl=url.substring(0, url.lastIndexOf(".")) + "xml.xml";
			}
			var vec:Vector.<BitmapInfo>=RoleBMDPool.instance._mcDic[xmlUrl];
			var names:Array=RoleBMDPool.instance._actDic[xmlUrl][act];
			var cls:Class=null;
			var centerToFoot:int=-1; //一个特殊属性
			var currDirection:int=-1; //资源对应的方向
			var linkKey:String;
			for each (var bif:BitmapInfo in vec)
			{
				//找到Vec中对应的状态
				if (bif.act == act)
				{ //只替换默认形象
//					if (bif.bitmapData == null || bif.bitmapData == ResDef.defautlBody)
					if (bif.texture == null || bif.texture == ResDef.defautlBody)
					{
						for each (var name:String in names)
						{
							if (bif.name == name)
							{
								linkKey=swfName + "_" + name;
								cls=ResTool.getCls(url, linkKey);
								if (cls) //延时切帧，降低消耗
								{
//									_cutList.push([bif, cls]);
									if (currDirection != bif.direction) //此处需要获得各个方向第一张资源图的高度，需要把位图数据创建出来
									{
										currDirection=bif.direction;
//										bif.bitmapData=ResTool.getBmd(url, linkKey);
//										bif.bitmapData=new cls();
										bif.texture=Texture.fromBitmapData(new cls());
										centerToFoot=bif.texture.height;
									}
									else
									{
										_cutList.push([bif, url, linkKey]);
											//放入队列中动态创建实例，不利于资源回收
//										bif.bitmapData=new cls();
									}
									bif.centerToFoot=centerToFoot;
								}
								else
								{
								}
								break;
							}
						}
					}
				}
			}
		}

		private function getBitmapInfoByName(bitmapName:String):BitmapInfo
		{
			var bitmapInfo:BitmapInfo=new BitmapInfo();
			bitmapInfo.name=bitmapName;
			var classInfo:Array=bitmapName.split("_");
			var state:String=classInfo[0];
			bitmapInfo.x=classInfo[1];
			bitmapInfo.y=classInfo[2];
			var fPoint:int=state.indexOf("F");
			bitmapInfo.act=state.substring(0, fPoint);
			bitmapInfo.mark=state.substring(0, fPoint + 2);
			return bitmapInfo;
		}

		private function romance(movie:ResMc, isMe:Boolean=false):void
		{
			if (!movie.stage)
				return;
			var jumpFrame:int=movie.jumpFrame;
			var isEffect:Boolean=false;
//			if (movie.parent.parent && Object(movie.parent.parent).hasOwnProperty('king') == false)
//				isEffect = true;
			isEffect=movie.isEffect;
//			if(movie.isMonster)
//				isEffect = false;
			//待机动作统一降低渲染帧频
			if (movie.act == 'D1' || movie.act == 'D10' || movie.act == 'D7')
			{
				if (movie.isMonster)
					jumpFrame=jumpFrame * 3 + (Math.random() * 6 >> 0);
				//低帧频下对所有待机角色都作降帧处理
				if (FrameMgr.isBad)
					jumpFrame=1 + jumpFrame * 3 + (Math.random() * 6 >> 0)
			}
			else
			{
				if (movie.isMonster)
					jumpFrame=jumpFrame * 2 + (Math.random() * 4 >> 0)
				if (FrameMgr.isBad)
					jumpFrame=jumpFrame * 3 + (Math.random() * 6 >> 0)
			}
			if (isEffect)
				jumpFrame=0;
			//根据当前胡帧频动态调整渲染胡间隔时间
			if (FrameMgr.isBad)
				jumpFrame+=3 + (Math.random() * 4 >> 0);
			jumpFrame+=1;
			if (isMe && (movie.act == "D5" || movie.act == "D11"))
				jumpFrame=movie.jumpFrame
			var value:int=30
			if (isEffect || (movie.act == "D3" || movie.act == "D4" || movie.act == "D9"))
			{
				jumpFrame=0;
				movie.delay=0
//				value=40;
			}
			else
			{
				movie.delay=(Math.random() * 30 >> 0)
			}
			if (movie.act == 'D1' || movie.act == 'D10' || movie.act == 'D7')
			{
				if (!isEffect)
				{
					if (FrameMgr.isBad)
					{
						movie.delay=90 + (Math.random() * 100 >> 0)
						value=500;
					}
					else
					{
						value=70;
					}
				}
			}
			var time:int=jumpFrame * frameTime + value + movie.delay;
			if (isMe && (movie.act == "D5" || movie.act == "D11"))
				time=70;
//			if (isEffect) 
//				time = movie.jumpFrame * frameTime;
			if (movie.playTime == -1) //未设置特定播放时间的，
			{
				if (movie.isEffect == false)
				{
					movie.playTime=RenderActDefaultTime[movie.act];
				}
				else
				{
					if (isEffect) //如果是技能，则根据配置来设置
						time=(movie.jumpFrame + 1) * frameTime;
					if (movie.frames != 0)
						movie.playTime=time * (movie.frames + 1);
					else
						movie.playTime=time * 4;
				}
				if (movie.isMonster)
				{
					movie.playTime=movie.playTime + 120 * Math.random();
				}
				else if (movie.isPick)
				{
					movie.playTime=movie.playTime + 300 * Math.random();
				}
			}
			if (FrameMgr.isBad)
			{
				if ((movie.act == "D1" || movie.act == 'D10' || movie.act == 'D7') && movie.isEffect == false)
				{
					movie.playTime=4000;
				}
			}
			//主角在移动中统一降低其他角色胡渲染帧频
			if (leadRole != null && (leadRole.act == "D5" || leadRole.act == "D6" || leadRole.act == "D11") && !isMe)
			{
				if (movie.isMine == false && (movie.isMonster || movie.isPick))
				{
					if (movie.act == "D2" || movie.act == "D7" || movie.act == "D8" || movie.act == "D11" || movie.act == "D13")
					{
						return;
					}
					movie.playTime=RenderActDefaultTime[movie.act] + Math.random() * 360;
				}
			}
			movie.update();
		}
	}
}
