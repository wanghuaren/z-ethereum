package scene.skill2
{
	import com.bellaxu.mgr.FrameMgr;
	import com.bellaxu.res.ResMc;
	import com.bellaxu.res.ResTool;
	import com.bellaxu.util.PathUtil;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SkillResModel;
	import common.managers.Lang;
	
	import engine.load.GamelibS;
	import engine.utils.HashMap;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.utils.setTimeout;
	
	import netc.Data;
	
	import scene.king.IGameKing;
	import scene.king.SkinBySkill;
	import scene.king.SkinParam;
	import scene.king.TargetInfo;
	import scene.manager.SceneManager;
	import scene.utils.MapCl;
	import scene.winWeather.WinWeaterEffectByJumpHuman;
	
	import ui.view.view2.other.CBParam;
	
	import world.FileManager;
	import world.WorldEvent;
	import world.WorldFactory;
	import world.model.file.BeingFilePath;
	import world.model.file.ItemFilePath;
	import world.model.file.SkillFilePath;
	import world.type.ItemType;

	public class SkillEffectManager
	{
		/**
		 * skillEffect的飞行时间
		 *
		 * distance决定使用time_min还是time_max
		 *
		 * 注意：由于动画跳帧1，2不同，又由于飞行第一帧为透明，因此为保证动画出来，
		 * 根据蒋总的意见调整飞行时间为0.15 , 0.3, 0.4
		 *
		 */
		public static const MOVE_TIME_MINMIN:Number=0.1;
		public static const MOVE_TIME_MIN:Number=0.25; //0.15;//0.1;//15;//
		public static const MOVE_TIME_MIDDLE:Number=0.4; //0.3;//0.2;//15;
		public static const MOVE_TIME_MAX:Number=0.5; //0.4;//0.25;//15;//
		public static const MOVE_DISTANCE_MIN:int=150; //;200
		public static const MOVE_DISTANCE_MIDDLE:int=400; //;

		public static const FUHUO_MOVE_TIME:Number=1.1; //0.3;
		public static const LVLUP_MOVE_TIME:Number=1.2;
		public static const MPADD_MOVE_TIME:Number=1.2;
		public static const HPADD_MOVE_TIME:Number=1.2;
		public static const CAIJI_MOVE_TIME:Number=1.7;
		public static const HOBANJOIN_MOVE_TIME:Number=2.4; //1.0;
		public static const PKKinger_MOVE_TIME:Number=1.5;
		public static const BiShaJi_Pet_MOVE_TIME:Number=3.0;

		/**
		 * 在元件未加载完成时使用该值
		 */
		public static const SKILL_400001_WIDTH:Number=50;
		public static const SKILL_400001_HEIGHT:Number=50;



		/**
		 *
		 */
		private static var _instance:SkillEffectManager;

		public function SkillEffectManager()
		{
			//GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,clockSecond);
		}

		public static function get instance():SkillEffectManager
		{
			if (!_instance)
			{
				_instance=new SkillEffectManager();
			}

			return _instance;
		}



		/**
		 * 对象池
		 *
		 * 基本技能
		 */
		private var _basicSkillPool:HashMap;

		public function get basicSkillPool():HashMap
		{
			if (null == _basicSkillPool)
			{
				_basicSkillPool=new HashMap();
			}

			return _basicSkillPool;
		}

		/**
		 * 对象池
		 *
		 * 和飘字类似或同时出现的效果
		 */
		private var _embedOtherPool:HashMap;

		public function get embedOtherPool():HashMap
		{
			if (null == _embedOtherPool)
			{
				_embedOtherPool=new HashMap();
			}

			return _embedOtherPool;
		}




		public function getEmbedOtherPool(libName:String):DisplayObject
		{
			var d:DisplayObject;

			//query
			if (embedOtherPool.containsKey(libName))
			{
				var subList:Array=embedOtherPool.get(libName);

				if (subList.length > 0)
				{
					d=subList.shift();

					d.addEventListener(Event.REMOVED_FROM_STAGE, EMBED_OTHER_REMOVED_FROM_STAGE);

					return d;
				}

			}

			//
			if (null == d)
			{
//项目转换				d=ResTool.getAppMc(libName);
				d=GamelibS.getswflink("game_index", libName);
				//有可能为null
				if (null != d)
				{
					d.name=libName;

					if (d as MovieClip)
					{
						(d as MovieClip).stop();
					}
					d.addEventListener(Event.REMOVED_FROM_STAGE, EMBED_OTHER_REMOVED_FROM_STAGE);
				}
			}
			//
			if (null == d)
			{
				//throw new Error("embed source can not be null:" + libName);
			}
			return d;
		}

		public function getPoolBy12(bfp:SkillFilePath):DisplayObject
		{
//			var libName:String=PathUtil.getFileName(bfp.swf_path0);
			var d:DisplayObject=null; //=WorldFactory.getMovie(libName);
			if (null == d)
			{
				var sk:SkinBySkill=WorldFactory.createSkinBySkill();
				sk.setSkin(bfp);
				d=sk;
			}
			//else
			//{
			//	(d as Movie).play();
			//}
			return d;
		}

		/**
		 * 创建影片
		 * SKILL_EFFECT_X 属于哪个阶段
		 * model_effectX 具体的值
		 */
		public function getPool(skill:int, skill_effectX:int, model_effectX:int, srcSex:int, srcId:int, ag:int=0, skillFX:String=null, skillPlayTime:int=-1):DisplayObject
		{
			//允许effect1无效果
			if (1 == skill_effectX && 0 == model_effectX)
			{
				return null;
			}

			//允许effect2无效果
			if ((2 == skill_effectX && 0 == model_effectX) || (FrameMgr.isBad && srcId != Data.myKing.objid && 2 == skill_effectX))
			{
				return null;
			}

			//从对象池取
			var libName:String=model_effectX.toString();

			var d:DisplayObject;

			var isBasicSkill:Boolean=false;

			var skillBaiscFilePath:String;

			var subList:Array;

			//401001	天斗普通攻击
			//401002	玄道普通攻击
			//401003	仙羽普通攻击
			if (("401001" == skill.toString() && 3 == skill_effectX) ||
				//("401002" == skill.toString() && 3 == skill_effectX) ||
				("401003" == skill.toString() && 3 == skill_effectX))
			{
				isBasicSkill=true;

				//仙羽普通攻击特殊处理
				if ("400002" == libName)
				{
					var srcKing:IGameKing=SceneManager.instance.GetKing_Core(srcId);

					if (null != srcKing)
					{

						if (3 == srcKing.metier && srcKing.level >= 15)
						{
							libName+="_Lvl_15";
						}
					}

				} //end if

			}
			if (!isBasicSkill)
			{
				//query
				if (basicSkillPool.containsKey(libName))
				{
					subList=basicSkillPool.get(libName);

					if (subList.length > 0)
					{
						d=subList.shift();
						d.x=0;
						d.y=0;

						//d.alpha = 0;

						d.addEventListener(Event.REMOVED_FROM_STAGE, BASIC_SKILL_REMOVED_FROM_STAGE);
						d.rotation=ag;
						return d;
					}

				}

				if (skill == 401206) //此处测试，暂时特殊处理
					model_effectX=0;
				//
				if (0 != model_effectX)
				{

					//					
					var bfp:SkillFilePath=FileManager.instance.getSkillFileByResModel(model_effectX);
					bfp.direction=skill_effectX;
					bfp.skillId=skill;
					bfp.playTime=skillPlayTime;
//					if (skill == 4013031){//施毒术 轨迹特效需要从特定帧循环播放
//						bfp.loopFrame = 4;
//					}

					libName=PathUtil.getFileName(bfp.swf_path0);

					//d=WorldFactory.getMovie(libName);
					d=null;

					if (null != d)
					{
						d.x=0;
						d.y=0;
						d.rotation=ag;

//						(d as ResMc).play();
						return d;
					}

					//
					var sk:SkinBySkill=WorldFactory.createSkinBySkill();

					sk.setSkin(bfp, ag, skillFX);

					return sk;

				} //end if				

			} //end  no basic skill




			//
			if (isBasicSkill)
			{
				//

				//query
				if (basicSkillPool.containsKey(libName))
				{
					subList=basicSkillPool.get(libName);

					if (subList.length > 0)
					{
						d=subList.shift();
						d.x=0;
						d.y=0;

						//d.alpha = 0;

						d.addEventListener(Event.REMOVED_FROM_STAGE, BASIC_SKILL_REMOVED_FROM_STAGE);

						return d;
					}

				}

				//load
				if (0 != model_effectX)
				{
					//skillBaiscFilePath = FileManager.instance.getSkillBasicFileById(model_effectX.toString());
					skillBaiscFilePath=FileManager.instance.getSkillBasicFileById(libName);

					var seLoader:SkillBasicEffectLoader=new SkillBasicEffectLoader(libName, skillBaiscFilePath);

					//no need addEvtListen remove stage
					return seLoader.loadAndGetld();
				}
			}
			//------------------------------------------------------------------------------------------------
			var p:Shape=new Shape();

			p.graphics.beginFill(0x000000);
			p.graphics.drawRect(0, 0, 2, 2);
			p.graphics.endFill();

			//p.alpha = 0;

			d=p;

			d.name=libName;

			//因优化，这里需要Event.REMOVED
			d.addEventListener(Event.REMOVED_FROM_STAGE, BASIC_SKILL_REMOVED_FROM_STAGE);

			d.addEventListener(Event.REMOVED, BASIC_SKILL_REMOVED);


			return d;
		}

		public function addPool(libName:String, d:DisplayObject):void
		{
			if (null == libName || null == d)
			{
				return;
			}

			if ("" == libName)
			{
				return;
			}

			//

			if (!basicSkillPool.containsKey(libName))
			{
				basicSkillPool.put(libName, []);

			}

			var subList:Array=basicSkillPool.get(libName);

			d.name=libName;

			subList.push(d);


		}

		//
		public function addEmbedOtherPool(libName:String, d:DisplayObject):void
		{
			if (null == libName || null == d)
			{
				return;
			}

			if ("" == libName)
			{
				return;
			}

			//		
			if (!embedOtherPool.containsKey(libName))
			{
				embedOtherPool.put(libName, []);

			}

			var subList:Array=embedOtherPool.get(libName);

			d.name=libName;

			subList.push(d);

			//
			if (d as MovieClip)
			{
				(d as MovieClip).stop();
			}


		}

		//------------------------------- basic skill pool begin --------------------
		public function BASIC_SKILL_REMOVED(e:Event):void
		{
			var d:DisplayObject=e.target as DisplayObject;

			d.removeEventListener(Event.REMOVED, BASIC_SKILL_REMOVED);

			this.addPool(d.name, d);


		}

		public function BASIC_SKILL_REMOVED_FROM_STAGE(e:Event):void
		{
			var d:DisplayObject=e.target as DisplayObject;

			d.removeEventListener(Event.REMOVED, BASIC_SKILL_REMOVED);
			d.removeEventListener(Event.REMOVED_FROM_STAGE, BASIC_SKILL_REMOVED_FROM_STAGE);

			this.addPool(d.name, d);


		}

		//------------------------------- basic skill pool end --------------------

		//
		public function EMBED_OTHER_REMOVED_FROM_STAGE(e:Event):void
		{
			var d:DisplayObject=e.target as DisplayObject;

			d.removeEventListener(Event.REMOVED_FROM_STAGE, EMBED_OTHER_REMOVED_FROM_STAGE);

			this.addEmbedOtherPool(d.name, d);


		}



		public function clockSecond(e:WorldEvent):void
		{


		}

		/**
		 * 第三阶段元件的创建
		 */
		public function createSkillEffect3And31(skill:int, targetInfo:TargetInfo):Array
		{
			//项目转换	var skill_model:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, skill.toString());
			var skill_model:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(skill) as Pub_SkillResModel;
			var list:Array=[];

			//3飞行轨迹必须要有，否则无法触发CFightInstant_Complete			
			//if(0 != model.effect3)
			//{
			var se3:SkillEffect3=WorldFactory.createItem(ItemType.SKILL, 3) as SkillEffect3;
			se3.setData(skill, targetInfo);
			list.push(se3);
			//}

			/* logic_id 只有是3时，表明有
				   此处由服务端走monterEnterGrid路线
			if(3 == model_data.logic_id)
			{
				model_special = XmlManager.localres.SkillSpecialXml.getResPath(model_data.para1);
			}
			*/
			if (null != skill_model)
			{
				if (0 != skill_model.effect4)
				{
					var se31:SkillEffect31=WorldFactory.createItem(ItemType.SKILL, 4) as SkillEffect31;
					se31.setData(skill, targetInfo);
					list.push(se31);
						//此处暂时不做优化
//					if (!FrameMgr.isBad)
//					{
//						var se31:SkillEffect31=WorldFactory.createItem(ItemType.SKILL, 4) as SkillEffect31;
//						se31.setData(skill, targetInfo);
//						list.push(se31);
//
//					}
//					else
//					{
//						Action.instance.fight.CFightInstant_Complete(targetInfo, skill);
//					}
				}
			}

			return list;
		}

		public function send(se:ISkillEffect):void
		{
			if(se==null) return;
			//list push


			//step1

			se.One_CreateEffect();

			//t = target
			se.Two_AddChild();
			//
			se.Three_Move();



		}

		/**
		 * 数组 【0】表示方向，null 表示方向和人物完全匹配5方向【1】表示偏移角度 -1表示不再偏移
		 * */
		public function getFXAndAngle(fx:int, turn:int):Array
		{
			var m_info:Array=[null, 0];
			switch (fx)
			{
				case 1:
					m_info[1]=0;
					break;
				case 2:
					m_info[1]=45;
					break;
				case 3:
					m_info[1]=90;
					break;
				case 4:
					m_info[1]=135;
					break;
				case 5:
					m_info[1]=180;
					break;
			}
			if (fx > 0)
			{
				m_info[0]="F" + fx;
			}
//			if (turn == 1)
//			{
//				m_info[1]=-1;
//			}
			return m_info;
		}

		/**
		 * 自身技能效果位置调整
		 *
		 * effect_pos 0表示人物身体中间
			1 脚下
			2 头顶
			3跟0也差不多
		 *
		 * movie3.x=movie3.originX-movie1.originX+movie1.x;
			movie3.y=movie3.originY-movie1.originY+movie1.y;
		 */
		private function AdjustBodyXYByEffect1(d:DisplayObject, effectPosX:int, targetInfo:TargetInfo, skill:int):void
		{
			//effect_pos 0表示人物身体中间
			//1 脚下
			//2 头顶
			//3跟0也差不多
			switch (effectPosX)
			{
				case 0:
				case 3:

					//脚下无区别
					if (d as ResMc)
					{
						//test ok

						AdjustBodyXYByEffect1Movie(d as ResMc, effectPosX, targetInfo);

					}
					else if (d as SkinBySkill)
					{
						AdjustBodyXYByEffect1Movie((d as SkinBySkill).getRole(), effectPosX, targetInfo);
					}
					else
					{
						d.x=0;
						d.y=d.height * -1;
					}

					break;

				case 1:

					if (d as ResMc)
					{
						AdjustBodyXYByEffect1Movie(d as ResMc, effectPosX, targetInfo);

					}
					else
					{
						d.x=0;
						d.y=targetInfo.src_height * 0.67 * -1;
					}

					break;

				case 2:

					//头顶无区别
					if (d as ResMc)
					{
						d.x=0;
						d.y=(targetInfo.src_height * 1.0 + SkinParam.HEAD_DISTANCE) * -1;

					}
					else
					{
						d.x=0;
						d.y=(targetInfo.src_height * 1.0 + SkinParam.HEAD_DISTANCE) * -1;
					}

					break;

					//default: throw new Error("undefined effectPosX:" + effectPosX.toString());			
			}
		}

		private function AdjustBodyXYByEffect2(d:DisplayObject, effectPosX:int, targetInfo:TargetInfo, skill:int):void
		{
			//effect_pos 0表示人物身体中间
			//1 脚下
			//2 头顶
			//3跟0也差不多
			switch (effectPosX)
			{
				case 0:
				case 3:

					if (d as ResMc)
					{

						AdjustBodyXYByEffect2Movie(d as ResMc, effectPosX, targetInfo, skill);

					}
					else if (d as SkinBySkill)
					{
						AdjustBodyXYByEffect2Movie((d as SkinBySkill).getRole(), effectPosX, targetInfo, skill);
					}
					else
					{
						d.x=0;
						d.y=d.height * -1;
					}

					break;

				case 1:

					if (d as ResMc)
					{
						AdjustBodyXYByEffect2Movie(d as ResMc, effectPosX, targetInfo, skill);

					}
					else
					{
						d.x=0;
						d.y=targetInfo.target_height * 0.67 * -1;
					}

					break;

				case 2:

					//头顶无区别
					if (d as ResMc)
					{
						d.x=0;
						d.y=(targetInfo.target_height * 1.0 + SkinParam.HEAD_DISTANCE) * -1;

					}
					else
					{
						d.x=0;
						d.y=(targetInfo.target_height * 1.0 + SkinParam.HEAD_DISTANCE) * -1;
					}

					break;

					//default: throw new Error("undefined effectPosX:" + effectPosX.toString());			
			}

		}

		//effect_pos 0表示人物身体中间
		//1 脚下
		//2 头顶
		//3跟0也差不多
		private function AdjustBodyXYByEffect2Movie(mo:ResMc, effectPosX:int, targetInfo:TargetInfo, skill:int):void
		{

			if (null == mo)
			{
				return;
			}

			var moH:Number=mo.height;
			var moW:Number=mo.width;


			if (0 == effectPosX || 3 == effectPosX)
			{

				if ("401001" == skill.toString() || "401003" == skill.toString())
				{
					mo.x=(moW * 0.5) * -1;

				}
				else
				{
					mo.x=0;
				}

			}

			//effect_pos 0表示人物身体中间
			//1 脚下
			//2 头顶
			//3跟0也差不多


			if (0 == effectPosX)
			{
				var tm:Number=targetInfo.target_height / moH;

				if (tm > 1.45)
				{
					//mo.y += moH * tm * -1 + moH/2;
					mo.y=0;
					mo.y+=(moH * tm) / 2 - targetInfo.target_height / 2;
				}
				else
				{
					//mo.y += moH * -1 + moH/2;							

					if (moH >= targetInfo.target_height)
					{
						mo.y=0;
						mo.y+=moH / 2 - targetInfo.target_height / 2;


					}
					else
					{
						mo.y=0;
						mo.y-=moH / 2 - targetInfo.target_height / 2;

					}

				}

			}

			if (3 == effectPosX)
			{
				//mo.y = Math.abs(moH *  0.5  - targetInfo.target_height *  0.5);										
				mo.y=targetInfo.target_height * 0.5;
			}


			if (1 == effectPosX)
			{
				mo.y=moH * -1;
			}

			if (2 == effectPosX)
			{
				mo.y=moH * -1 + targetInfo.target_height;
			}

		}

		//effect_pos 0表示人物身体中间
		//1 脚下
		//2 头顶
		//3跟0也差不多
		public function AdjustBodyXY(d:DisplayObject, effectPosX:String, targetInfo:TargetInfo, effectX:int, skill:int):void
		{
			if (d == null)
				return;

			var m_p:Array=effectPosX.split(",");
			d.x=int(m_p[0]);
			d.y=int(m_p[1]);
			if (d as ResMc)
			{
				(d as ResMc).setContentXY(m_p[2], m_p[3]);
			}
			else if (d as Sprite)
			{
				var m_sprite:Sprite=d as Sprite;
				var m_num:int=m_sprite.numChildren;
				while (m_num--)
				{
					d=m_sprite.getChildAt(m_num);
					if (d as ResMc)
					{
						(d as ResMc).setContentXY(m_p[2], m_p[3]);
						break;
					}
				}
			}
		}

//		public function adjustRotation(d:DisplayObject, p:Point):void
//		{
//			var m_len:int=d.height / 2;
//			d.x=p.x + m_len * Math.cos(Math.PI * ((d.rotation + 90) / 180));
//			d.y=p.y + m_len * Math.sin(Math.PI * ((d.rotation + 90) / 180));
//		}
		private var effectPos:Point=new Point();

		private function AdjustBodyXYByEffect1Movie(mo:ResMc, effectPosX:int, targetInfo:TargetInfo):void
		{
			if (null == mo)
			{
				return;
			}

			mo.x=0;
			mo.y=0;

			var moH:Number=mo.height;

			//
			if (0 == effectPosX || 3 == effectPosX)
			{
				mo.y=Math.abs(moH * 0.5 - targetInfo.src_height * 0.5);
			}

			if (1 == effectPosX)
			{
				mo.y=mo.height * -1;
			}

			if (2 == effectPosX)
			{
				mo.y=mo.height * -1 + (targetInfo.src_height * 0.67);
			}


		}

		/**
		 * 打中怪物的1/2处
		 */

		public function AdjustEndMapXYBySKE3(targetInfo:TargetInfo, skill_effectX_width:Number, skill_effectX_height:Number, skill_effectX_as_Movie:Boolean, skill:int, angle:int):Point
		{
			var srcFx:String;

			//			
			srcFx="F" + MapCl.getFXtoInt(angle);
			var px:int=MapCl.gridXToMap(targetInfo.target_mapx);
			var py:int=MapCl.gridYToMap(targetInfo.target_mapy);
			if (skill_effectX_as_Movie)
			{

				return new Point(px, py - targetInfo.target_height * 0.5);

			}

			return new Point(px, py - targetInfo.target_height * 0.5 - skill_effectX_height / 2);

		}

		public function AdjustEndMapXY(targetInfo:TargetInfo, skill_effectX_width:Number, skill_effectX_height:Number, skill_effectX_as_Movie:Boolean):Point
		{
			var px:int=MapCl.gridXToMap(targetInfo.target_mapx);
			var py:int=MapCl.gridYToMap(targetInfo.target_mapy);
			if (skill_effectX_as_Movie)
			{
				return new Point(px, py - targetInfo.target_height * 0.5 + skill_effectX_height / 2);


			}

			return new Point(px, py - targetInfo.target_height * 0.5 - skill_effectX_height / 2);

		}

		/**
		 * 打中怪物的脚下
		 */
		public function AdjustEndMapXYByFoot(targetInfo:TargetInfo, skill_effectX_width:Number, skill_effectX_height:Number, skill_effectX_as_Movie:Boolean):Point
		{
			var px:int=MapCl.gridXToMap(targetInfo.target_mapx);
			var py:int=MapCl.gridYToMap(targetInfo.target_mapy);

			if (skill_effectX_as_Movie)
			{
				return new Point(px,
					//targetInfo.target_mapy + skill_effectX_height / 2);
					py - skill_effectX_height / 2);

			}

			return new Point(px, py);

		}

		/**
		 * 打中怪物的脚下
		 * 无轨特效专用
		 */
		public function AdjustEndMapXYByEffect31Foot(targetInfo:TargetInfo, skill_effectX_width:Number, skill_effectX_height:Number, skill_effectX_as_Movie:Boolean, skill:int, skillInfo:Pub_SkillResModel):Point
		{
//			//这个是往斜下飞的
//			if ("401021" == skill.toString())
//			{
//				return new Point(targetInfo.target_mapx - 140, targetInfo.target_mapy - 280);
//			}
//
//			if ("401006" == skill.toString() || "401011" == skill.toString())
//			{
//				return new Point(targetInfo.target_mapx, targetInfo.target_mapy + skill_effectX_height / 2);
//			}
//
//			if ("401057" == skill.toString())
//			{
//				return new Point(targetInfo.target_mapx, targetInfo.target_mapy);
//			}
//
//			//------------------------------------------------------
//
//			if ("401055" == skill.toString())
//			{
//				if (skill_effectX_height < 500)
//				{
//					skill_effectX_height=500;
//				}
//				return new Point(targetInfo.target_mapx, targetInfo.target_mapy - skill_effectX_height / 2);
//			}
//
//			if (skill_effectX_as_Movie)
//			{
//				return new Point(targetInfo.target_mapx, targetInfo.target_mapy - skill_effectX_height / 2);
//
//			}
//			return new Point(targetInfo.target_mapx, targetInfo.target_mapy);

			var px:int=MapCl.gridXToMap(targetInfo.target_mapx);
			var py:int=MapCl.gridYToMap(targetInfo.target_mapy);

			var m_p:Point=new Point(skillInfo.effect_pos4.split(",")[0], skillInfo.effect_pos4.split(",")[1]);
			if (isNaN(m_p.x))
				m_p.x=0;
			if (isNaN(m_p.y))
				m_p.y=0;
			return new Point(px + m_p.x, py + m_p.y);
		}

		//修正技能施法的起始点位置
		public function adjustSkillStartFlyPosition(from:Point, to:Point):Boolean
		{
			var isNear:Boolean=false;
			var dir:Point=to.subtract(from);

			var dx:int=0;
			var dy:int=0;
			if (dir.x < 1)
			{
				dx=-1;
			}
			else if (dir.x > 1)
			{
				dx=1;
			}
			if (dir.y < 1)
			{
				dy=-1;
			}
			else if (dir.y > 1)
			{
				dy=1;
			}

			if (Math.abs(dir.x) < 2 && Math.abs(dir.y) < 2)
			{
				isNear=true;
			}

//			from.x+=dx;
//			from.y+=dy;
			return isNear;
		}


		//--------------------------- 提前加载其它 movie begin ----------------------------
		public function preLoadOther(my_lvl:int, my_sex:int, map_id:int):void
		{
			var swim_map_list:Array=Lang.getLabelArr("swim_map");
			var yjf_map_list:Array=Lang.getLabelArr("yjf_map");
			var spa_map_list:Array=Lang.getLabelArr("spa_map");
			var motian_map_list:Array=Lang.getLabelArr("motian_map");
			var jump_map_list:Array=Lang.getLabelArr("jump_map");
			var boat_map_list:Array=Lang.getLabelArr("boat_map");

			var hasSwim:Boolean=false;
			var hasYjf:Boolean=false;
			var hasSpa:Boolean=false;
			var hasMoTian:Boolean=false;
			var hasJump:Boolean=false;
			var hasBoat:Boolean=false;

			//
			var i:int;

			//
			if (null != swim_map_list)
			{

				for (i=0; i < swim_map_list.length; i++)
				{

					if (map_id == swim_map_list[i])
					{
						if (my_lvl >= 5)
						{
							hasSwim=true;
							break;
						}
					}

				}

			}

			//
			if (null != yjf_map_list)
			{

				for (i=0; i < yjf_map_list.length; i++)
				{

					if (map_id == yjf_map_list[i])
					{
						if (my_lvl >= 5)
						{
							hasYjf=true;
							break;
						}
					}

				}

			}

			//
			if (null != spa_map_list)
			{

				for (i=0; i < spa_map_list.length; i++)
				{

					if (map_id == spa_map_list[i])
					{
						if (my_lvl >= 1)
						{
							hasSpa=true;
							break;
						}
					}

				}

			}


			//
			if (null != motian_map_list)
			{

				for (i=0; i < motian_map_list.length; i++)
				{

					if (map_id == motian_map_list[i])
					{
						if (my_lvl >= CBParam.ArrDoJie_On_Lvl)
						{
							hasMoTian=true;
							break;
						}
					}

				}

			}


			if (null != jump_map_list)
			{

				for (i=0; i < jump_map_list.length; i++)
				{

					if (map_id == jump_map_list[i])
					{
						hasJump=true;
						break;
					}

				}

			}


			if (null != boat_map_list)
			{

				for (i=0; i < boat_map_list.length; i++)
				{

					if (map_id == boat_map_list[i])
					{
						hasBoat=true;
						break;
					}

				}

			}

			//----------------------------------------------------------------------------

			var bfp:ItemFilePath;
			var bfp2:ItemFilePath;

			if (hasSwim)
			{
				//Main_31010002Mxml.xml				
				var swin_fp:BeingFilePath=FileManager.instance.getMainByHumanId(0, 0, 31010002, 0, my_sex);

				bfp=new ItemFilePath(swin_fp.swf_path2, swin_fp.xml_path2);

				preLoadMovie(bfp);
			}

			if (hasYjf)
			{

				var yjf_sword_fp:SkillFilePath=FileManager.instance.getSkill12FileByFileName("yjf_sword");

				bfp=new ItemFilePath(yjf_sword_fp.swf_path0, yjf_sword_fp.xml_path0);

				preLoadMovie(bfp);

				//
				var yjf_cloud_fp:SkillFilePath=FileManager.instance.getSkillSoulFileByFileName("yjf_cloud");

				bfp2=new ItemFilePath(yjf_cloud_fp.swf_path0, yjf_cloud_fp.xml_path0);

				preLoadMovie(bfp2);
			}

			if (hasSpa)
			{

			}

			if (hasMoTian)
			{




			}

			if (hasJump)
			{
				WinWeaterEffectByJumpHuman.getInstance().open();

				setTimeout(cacelPreload, 2000);
			}

			if (hasBoat)
			{

				var boat_fp:SkillFilePath=FileManager.instance.getSkill12FileByFileName("yu_boat");

				bfp=new ItemFilePath(boat_fp.swf_path0, boat_fp.xml_path0);

				preLoadMovie(bfp);

			}

		}

		public function cacelPreload():void
		{
			WinWeaterEffectByJumpHuman.getInstance().winClose();

		}

		private function preLoadMovie(bfp:ItemFilePath):void
		{
			var names0:String=PathUtil.getFileName(bfp.swf_path0);
			var names1:String=PathUtil.getFileName(bfp.xml_path0);
			var swfUrl:String=PathUtil.getTrimPath(bfp.swf_path0);
			var xmlUrl:String=PathUtil.getTrimPath(bfp.xml_path0);

			if (ResTool.isLoaded(swfUrl) && ResTool.isLoaded(xmlUrl))
				return;
			ResTool.load(PathUtil.getTrimPath(bfp["swf_path0"]), null, null, null, new ApplicationDomain());
			ResTool.load(PathUtil.getTrimPath(bfp["xml_path0"]), null, null, null, new ApplicationDomain());
		}

		//--------------------------- 提前加载其它 movie end ----------------------------

		//---------------------------- 提前加载技能 begin ----------------------------

		public function preLoad(skill:int, srcSex:int):void
		{
			var len:int=4;
			var i:int;
			var model_effectX:int;

			//res
			//项目转换		var model:Pub_SkillResModel= Lib.getObj(LibDef.PUB_SKILL, skill.toString());
			var model:Pub_SkillResModel=XmlManager.localres.getSkillXml.getResPath(skill) as Pub_SkillResModel;
			if (null == model)
			{
				return;
			}

			//isBasicSkill
			if (FileManager.instance.isBasicSkillEffect(skill))
			{
				for (i=1; i <= len; i++)
				{
					model_effectX=model["effect" + i.toString()];

					if (0 == model_effectX)
					{
						continue;
					}

					var libName:String=model_effectX.toString();

					if (!basicSkillPool.containsKey(libName))
					{
						var skillBaiscFilePath:String=FileManager.instance.getSkillBasicFileById(libName);

						//至少加载2个备用
						//考虑ie线程等原因，设置为2较妥
						//还要加载其它的东西
						for (var j:int=0; j < 2; j++)
						{
							var seLoader:SkillBasicEffectLoader=new SkillBasicEffectLoader(libName, skillBaiscFilePath);

							//no need addEvtListen remove stage
							//return seLoader.loadAndGetld();

							//cache,no need get return
							seLoader.loadAndCache();
						}

					}

				} //end for

				return;
			}


			//skill
			//effect1 - 4

			for (i=1; i <= len; i++)
			{
				model_effectX=model["effect" + i.toString()];

				if (0 == model_effectX)
				{
					continue;
				}

				//没资源
				if (400001 == model_effectX || 400065 == model_effectX)
				{
					continue;
				}



				//			
				var bfp:SkillFilePath=FileManager.instance.getSkillFileByResModel(model_effectX);

				//
				var names0:String=PathUtil.getFileName(bfp.swf_path0);
				var names1:String=PathUtil.getFileName(bfp.xml_path0);
				var swfUrl:String=PathUtil.getTrimPath(bfp.swf_path0);
				var xmlUrl:String=PathUtil.getTrimPath(bfp.xml_path0);

				//
				if (ResTool.isLoaded(swfUrl) && ResTool.isLoaded(xmlUrl))
				{
					continue;
				}
//				if(roleLoadable.xml.act.(@m==_act.replace("D",""))==undefined){
//					return;
//				}

//				var sl_swf:Loader=new Loader();
//				sl_swf.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
//				{
//				});
//				sl_swf.load(new URLRequest(bfp["swf_path0"]));



			} //end for




		}

		//--------------------------- 提前加载技能 end --------------------------

		public function getMovieFirstFrameWidth(skill:int, skill_effect_X:int):Number
		{
			var skH:Number=0.0;

			var key:String=skill.toString() + "_" + skill_effect_X.toString();

			switch (key)
			{
				case "401002_3":
					skH=85;
					break;
				case "Skill_40039":
					skH=80;
					break;
			}

			return skH;
		}

		public function getMovieFirstFrameHeight(skill:int, skill_effect_X:int):Number
		{
			var skH:Number=0.0;

			var key:String=skill.toString() + "_" + skill_effect_X.toString();

			switch (key)
			{
				case "401002_3":
					skH=94;
					break;
				case "Skill_40039":
					skH=161;
					break;
			}

			return skH;
		}

		/**
		 * 预加载技能资源
		 * @param skill 技能ID
		 * @param targetInfo 目标信息
		 */
		public function preloadBasicSkill(skill:int, targetInfo:TargetInfo):void
		{
			var se3:SkillEffect3=WorldFactory.createItem(ItemType.SKILL, 3) as SkillEffect3;
			se3.setData(skill, targetInfo);
		}



	}
}
