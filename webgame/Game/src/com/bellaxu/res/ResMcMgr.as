package com.bellaxu.res
{
	import com.bellaxu.debug.Debug;
	import com.bellaxu.def.ResDef;
	import com.bellaxu.def.ResPriorityDef;
	import com.bellaxu.def.TimeDef;
	import com.bellaxu.mgr.FrameMgr;
	import com.bellaxu.mgr.TimeMgr;
	import com.bellaxu.mgr.TimerMgr;
	import com.bellaxu.res.pool.BitmapInfoPool;
	import com.bellaxu.res.pool.ResMcPool;
	import com.bellaxu.struct.IBitmapInfo;
	import com.bellaxu.util.PathUtil;
	import com.bellaxu.util.SysUtil;
	
	import engine.utils.FPSUtils;
	
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import netc.Data;

	/**
	 * mc资源管理，包括如下功能
	 * <br/>----1.切帧速度控制
	 * <br/>----2.加载完自动更新
	 * <br/>----3.索引计数
	 * <br/>----4.自动回收
	 * @author  BellaXu
	 */
	public final class ResMcMgr
	{
		private static const COUNT_DIC:Dictionary=new Dictionary(); //索引计数
		private static const CUT_FRAMES:uint=5;

		public static var leadRoleSkin:Array;

		private static var frameTime:Number=33.33;
		private static var FrameTimeOffset:int=0;
		private static var leadRole:ResMc;

		private static var _actDic:Dictionary=new Dictionary(); //swf对应的资源的所有状态的方向列表
		private static var _actResLoadedDic:Dictionary=new Dictionary(); //swfd对应所有动作上初始化的资源数量
		private static var _mcDic:Dictionary=new Dictionary(); //缓存所有Mc的BitmapDatas
		private static var _cutList:Vector.<Array>=new <Array>[];
		private static var _runList:Vector.<ResMc>=new <ResMc>[]; //播放中的资源列表
		private static var _runList2:Vector.<ResMcExt>=new <ResMcExt>[];
		private static var _runList3:Vector.<ResMcExt2>=new <ResMcExt2>[];

		private static var _stage:Stage;
		
		public static function init(stage:Stage):void
		{
			_stage = stage;
			ResMcPool.init();
			BitmapInfoPool.init();
			frameTime = Number(Number(1000 / _stage.frameRate).toFixed(2));//针对原有的技能特效配置固定30帧，这样能保证动画实际播放帧频或时间的统一
//			TimerMgr.getInstance().add(TimeDef.ms300000, timeGc);
		}

		public static function clean():void
		{
			var vec:Vector.<IBitmapInfo>;
			var tmpResDic:Dictionary;
			var count:int=0;
			var info:IBitmapInfo;
			for (var key:String in _mcDic)
			{
				vec=_mcDic[key];
				tmpResDic=_actResLoadedDic[key];
				count=COUNT_DIC[key];
				if (count <= 0)
				{
					for each (info in vec)
					{
						info.destory(true);
					}
					for (var key1:String in tmpResDic)
					{
						delete tmpResDic[key1];
					}
					vec.length=0;
					delete _mcDic[key];
					delete _actResLoadedDic[key]; //清除缓存的资源加载记录
					delete COUNT_DIC[key];
				}
			}
		}

		public static function timeGc():void
		{
			Debug.notice("============================Time GC Start=================================");
			//定时回收，30秒一次
			var vec:Vector.<IBitmapInfo>;
			var tmpResDic:Dictionary;
			var count:int=0;
			var info:IBitmapInfo;
			var dic:Dictionary=COUNT_DIC;
			for (var key:String in _mcDic)
			{
				vec=_mcDic[key];
				tmpResDic=_actResLoadedDic[key];
				count=COUNT_DIC[key];
				if (count <= 0)
				{
					for each (info in vec)
					{
						info.destory();
						//BitmapInfoPool.recycle(info);
					}
					for (var key1:String in tmpResDic)
					{
						delete tmpResDic[key1];
					}
					vec.length=0;
					delete _mcDic[key];
					delete _actResLoadedDic[key]; //清除缓存的资源加载记录
					delete COUNT_DIC[key];
					//清除对应的位图数据缓存
					clearKeySwfUrlsRes(key);
					Debug.notice("Time GC Release: " + key);
					checkMovieInRunList(key);
				}
			}
			Debug.notice("==============================Time GC End==================================");
		}
		
		private static function checkMovieInRunList(key:String):void
		{
			var count:int = 0;
			for each (var rm:ResMc in _runList)
			{
				if (rm.mcName == key)
				{
					count++;
				}
			}
			Debug.notice("movie::"+key+", left count:"+count);
		}
		
		private static function clearKeySwfUrlsRes(key:String):void
		{
			var list:Vector.<String> = KeyToUrlDict[key];
			if (list)
			{
				for each (var url:String in list)
				{
					ResBmd.delBmd(url);
					ResTool.unload(url);
				}
				list.length = 0;
			}
		}

		public static function render():void
		{
			var ary:Array=null;
			//一帧切5张图，差不多是一个形象的基本要素
			var info:IBitmapInfo=null;
			var li:int=_cutList.length - CUT_FRAMES;
			for (var i:int=_cutList.length - 1; i > -1 && i > li; i--)
			{
				ary=_cutList.shift();
				info=ary[0];
				if (info.isDestroyed)
					continue; //被销毁了就不用再切了
				info.bitmapData=ResTool.getBmd(ary[1], ary[2]);
			}
			if (leadRoleSkin != null)
			{
				leadRole=leadRoleSkin[2];
				if (leadRole != null)
					romance(leadRole, true);
			}

			if (_runList.length > 0)
			{
				var index:int=0;
				var movie:ResMc;
				while (index < _runList.length)
				{
					movie=_runList[index];
					if (leadRole != movie)
						romance(movie);
					index++;
				}
			}
			var runList2:Vector.<ResMcExt>=_runList2;
			for each (var ext:ResMcExt in runList2)
			{
				ext.render();
			}
			var runList3:Vector.<ResMcExt2>=_runList3;
			for each (var ext2:ResMcExt2 in runList3)
			{
				ext2.render();
			}
		}

		public static function getByXml(xmlUrl:String):ResMc
		{
			var mcName:String=PathUtil.getFileName(xmlUrl);
			mcName=mcName.replace("xml", "");
			if (!_mcDic[mcName])
				decode(xmlUrl, mcName);
			var mc:ResMc=ResMcPool.pop();
			mc._undisposed_=true; //重新启用
			mc.mcName=mcName;
			mc.movie=_mcDic[mcName];
			//计数
			if (!COUNT_DIC[mcName])
				COUNT_DIC[mcName]=0;
			COUNT_DIC[mcName]++;
			if (xmlUrl.indexOf("Effect") >= 0)
			{
				mc.fpsTime=getTimer();
				mc.isPart=true;
				mc.isEffect=true;
			}
			else
				mc.fpsTime=getTimer() + (Math.random() * 500 >> 0);
			return mc;
		}

		public static function release(mc:ResMc):void
		{
			if (mc && mc.mcName && COUNT_DIC[mc.mcName])
				COUNT_DIC[mc.mcName]--;
		}

		public static function play(mc:Object):void
		{
			if (mc is ResMc)
			{
				if (_runList.indexOf(mc) < 0)
					_runList.push(mc);
			}
			else if (mc is ResMcExt)
			{
				if (_runList2.indexOf(mc) < 0)
					_runList2.push(mc);
			}
			else if (mc is ResMcExt2)
			{
				if (_runList3.indexOf(mc) < 0)
					_runList3.push(mc);
			}
		}

		public static function stop(mc:Object):void
		{
			var m_index:int;
			if (mc is ResMc)
			{
				m_index=_runList.indexOf(mc);
				if (_runList.indexOf(mc) >= 0)
					_runList.splice(m_index, 1);
			}
			else if (mc is ResMcExt)
			{
				m_index=_runList2.indexOf(mc);
				if (_runList2.indexOf(mc) >= 0)
					_runList2.splice(m_index, 1);
			}
		}

		public static function isRunning(movie:ResMc):Boolean
		{
			return _runList.indexOf(movie) >= 0;
		}

		/**
		 * 判断当前动作的资源是否加载完毕
		 */
		public static function isResLoadedInAct(key:String, act:String):Boolean
		{
			var result:Boolean=false;
			var totalFramesForAllActs:Dictionary=_actDic[key];
			var loadedFrameCountForAllActs:Dictionary=_actResLoadedDic[key];
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
		private static function decode(xmlUrl:String, key:String):void
		{
			var xml:XML=ResTool.getXml(xmlUrl);
			if (!xml)
			{
				Debug.error("找不到资源对应的xml文件：" + xmlUrl);
				return;
			}
			//默认的形象，如果是技能或者坐骑则为null
			var defaultBmd:BitmapData=null;
			if (xmlUrl.indexOf("Effect") < 0)
				defaultBmd=ResDef.defautlBody;

			var infoVec:Vector.<IBitmapInfo>=new <IBitmapInfo>[];
			var neededActs:Vector.<String>=new <String>[];
			var tmpDic:Dictionary=new Dictionary();
			var tmpResDic:Dictionary=new Dictionary();
			var bitmapInfo:IBitmapInfo=null;
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
						bitmapInfo.bitmapData=defaultBmd;
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
			_actDic[key]=tmpDic;
			_actResLoadedDic[key]=tmpResDic;
			_mcDic[key]=infoVec;
			loadNeededRes(neededActs, xmlUrl.substring(0, xmlUrl.indexOf("xml")));
		}

		private static function loadNeededRes(dirList:Vector.<String>, mcPreUrl:String):void
		{
			for each (var dir:String in dirList)
			{
				ResTool.load(mcPreUrl + (dir == "D1" ? "" : dir) + ".swf", onLoadedNeededRes, null, null, null, (mcPreUrl.indexOf(Data.myKing.s2 + "") > -1 ? ResPriorityDef.SHIGH : ResPriorityDef.NORMAL));
			}
		}
		
		public static var KeyToUrlDict:Dictionary = new Dictionary();
		
		private static function saveKeySwfUrls(mcName:String,url:String):void
		{
			var list:Vector.<String> = KeyToUrlDict[mcName];
			if (list==null)
			{
				list = new Vector.<String>();
				KeyToUrlDict[mcName] = list;
			}
			if (list.indexOf(url)==-1)
			{
				list.push(url);
			}
		}

		private static function onLoadedNeededRes(url:String):void
		{
			var swfName:String=PathUtil.getFileName(url);
			var index:int=swfName.indexOf("D");
			//项目转换修改 var xmlUrl:String = url.substring(0, url.indexOf(".")) + "xml.xml";
			var xmlUrl:String=url.substring(0, url.lastIndexOf(".")) + "xml.xml";
			var act:String="D1";
			if (index > -1)
			{
				act=swfName.substring(index, swfName.length);
				swfName=swfName.substring(0, index);
				xmlUrl=url.substring(0, url.indexOf("D")) + "xml.xml";
			}
			var mcName:String=PathUtil.getFileName(xmlUrl);
			mcName=mcName.replace("xml", "");
			saveKeySwfUrls(mcName,url);
			//替换空位图
			var vec:Vector.<IBitmapInfo>=_mcDic[mcName];
			if (!vec) //可能在加载的过程中被回收，不需要切了
				return;
			var names:Array=_actDic[mcName][act];
			var cls:Class=null;
			var centerToFoot:int=-1; //一个特殊属性
			var currDirection:int=-1; //资源对应的方向
			var linkKey:String;
			for each (var bif:IBitmapInfo in vec)
			{
				//找到Vec中对应的状态
				if (bif.act == act)
				{ //只替换默认形象
					if (bif.bitmapData == null || bif.bitmapData == ResDef.defautlBody)
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
										bif.bitmapData=ResTool.getBmd(url, linkKey);
										centerToFoot=bif.bitmapData.height;
									}
									else
									{
										_cutList.push([bif, url, linkKey]);
									}
									bif.centerToFoot=centerToFoot;
								}
								else
								{
									Debug.error("ERROR!找不到对应资源-"+linkKey+">>"+url);
								}
								break;
							}
						}
					}
				}
			}
		}

		private static function getBitmapInfoByName(bitmapName:String):IBitmapInfo
		{
			var bitmapInfo:IBitmapInfo=BitmapInfoPool.pop();
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

		private static function romance(movie:ResMc, isMe:Boolean=false):void
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
				value=40;
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
				if ((movie.act == "D1" || movie.act == 'D10' || movie.act == 'D7') && movie.isEffect == false)
				{
					movie.playTime=2000;
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
					movie.playTime+=180;
				}
			}
			movie.update();
		}

	}
}
