package scene.skill2
{
	import com.bellaxu.def.DepthDef;
	import com.bellaxu.def.MusicDef;
	import com.bellaxu.mgr.MusicMgr;
	import com.bellaxu.res.ResMc;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;

	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SkillResModel;
	import common.managers.Lang;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;

	import netc.Data;

	import scene.action.Action;
	import scene.event.KingActionEnum;
	import scene.king.IGameKing;
	import scene.king.SkinBySkill;
	import scene.king.TargetInfo;
	import scene.manager.SceneManager;
	import scene.utils.MapCl;

	import world.FileManager;
	import world.WorldFactory;
	import world.graph.WorldSprite;
	import world.type.BeingType;

	/**
	 * 与3不同，此类继承sprite即可
	 */
	public class SkillEffect2 extends WorldSprite implements ISkillEffect
	{
		/**
		 * 对方身上特效
		 * */
		public static const SKILL_EFFECT_X:int=2;
		/**
		 * 内容的默认播放次数
		 */
		public static const D_AS_MOVIE_PLAY_COUNT:int=1; //1
		/**
		 * 技能资源ID
		 */
		private var m_nSkillModelId:int;

		public function get skillModelId():int
		{
			return m_nSkillModelId;
		}
		//
		public var skill:int;
		public var targetInfo:TargetInfo;
		//
		public var moveTime:Number;
		/**
		 * 击退效果
		 */
		public var driveOff:Boolean;
		public var delayCallFour:Boolean;

		public function get driveOffTime():Number
		{
			var arrDriveOff:Array=Lang.getLabelArr("arr_driveOff");
			if (null != arrDriveOff && arrDriveOff.length > 0)
			{
				return arrDriveOff[2];
			}
			return 1.0;
		}

		public function get driveOffDistanceX():int
		{
			var arrDriveOff:Array=Lang.getLabelArr("arr_driveOff");
			if (null != arrDriveOff && arrDriveOff.length > 0)
			{
				return arrDriveOff[0];
			}
			return 200;
		}

		public function get driveOffDistanceY():int
		{
			var arrDriveOff:Array=Lang.getLabelArr("arr_driveOff");
			if (null != arrDriveOff && arrDriveOff.length > 0)
			{
				return arrDriveOff[1];
			}
			return 100;
		}

		public function get driveOffMode():int
		{
			var arrDriveOff:Array=Lang.getLabelArr("arr_driveOff");
			if (null != arrDriveOff && arrDriveOff.length > 0)
			{
				return arrDriveOff[4];
			}
			return 0;
		}

		override public function get svr_stop_mapx():Number
		{
			//暂未设置
			return -1;
		}

		override public function get svr_stop_mapy():Number
		{
			//暂未设置
			return -1;
		}

		public function get DZ():String
		{
			return KingActionEnum.SJ;
		}
		private var offsetAngle:int=0;

		public function getFx(k_roleFX:String):String
		{
			var m_info:Array=SkillEffectManager.instance.getFXAndAngle(skill_model.effect_fx2, skill_model.effect_turn2);
			if (m_info[0] != null)
				k_roleFX=m_info[0];
			offsetAngle=m_info[1];
			return k_roleFX;
		}

		public function get skill_model():Pub_SkillResModel
		{
//项目转换			return Lib.getObj(LibDef.PUB_SKILL, skill.toString());
			return XmlManager.localres.getSkillXml.getResPath(skill) as Pub_SkillResModel;
		}

		public function SkillEffect2()
		{
		}

		/**
		 * 本类不需要objid
		 */
		override public function get name2():String
		{
			return "";
		}

		/**
		 * @private
		 */
		override public function set name2(value:String):void
		{
			//_name2 = value;
		}

		override public function get mapy():Number
		{
			return 0;
		}

		override public function get mapx():Number
		{
			return 0;
		}

		override public function set mapy(value:Number):void
		{
			//_mapy = value;
		}

		override public function set mapx(value:Number):void
		{
			//_mapx = value;
		}

		public function init():void
		{
			this.mouseEnabled=this.mouseChildren=false;
			this.visible=true;
			this.skill=0;
			this.targetInfo=null;
			this.driveOff=false;
			this.delayCallFour=false;
			this.depthPri=DepthDef.TOP;
			this.removeEventListener(Event.REMOVED_FROM_STAGE, WorldFactory.SKILL_EF_2_REMOVED_FROM_STAGE);
			this.clear();
			this.addEventListener(Event.REMOVED_FROM_STAGE, WorldFactory.SKILL_EF_2_REMOVED_FROM_STAGE);
		}

		public function setData(skill_:int, targetInfo_:TargetInfo):void
		{
			this.m_nSkillModelId=this.skill=skill_;
			this.targetInfo=targetInfo_.clone();
			//test
		/*
		this.graphics.clear();
		this.graphics.beginFill(0x001100);
		this.graphics.drawRect(0,0,50,50);
		this.graphics.endFill();
		*/
		}

		/**
		 * 判定是否要有击退效果
		 * 当没有击退效果的时候   怪物要打飞
		 * */
		public function setDriveOff(value:Boolean):void
		{
			//test
			//this.driveOff=true;
			this.driveOff=value;
		}

		public function get target_info():TargetInfo
		{
			return this.targetInfo.clone();
		}

		public function get isMe():Boolean
		{
			return this.targetInfo.srcid == Data.myKing.objid ? true : false;
		}

		public function get isMePet():Boolean
		{
			var curPetId:int=Data.myKing.CurPetId;
			var myKingRoleId:int=Data.myKing.roleID;
			var byCurPetId:Boolean=this.targetInfo.srcid == curPetId ? true : false;
			if (byCurPetId)
			{
				return byCurPetId;
			}
			//
			var byMasterId:Boolean=false;
			var srcK:IGameKing=srcKing;
			if (null != srcK)
			{
				byMasterId=srcK.masterId == myKingRoleId ? true : false;
			}
			return byMasterId;
		}

		public function get isMeMon():Boolean
		{
			var myKingRoleId:int=Data.myKing.roleID;
			var byMasterId:Boolean=false;
			var srcK:IGameKing=srcKing;
			if (null != srcK)
			{
				byMasterId=srcK.masterId == myKingRoleId ? true : false;
			}
			return byMasterId;
		}

		/**
		 * 创建效果文件
		 */
		public function One_CreateEffect():void
		{
			One_Sub_SysConfig();
			var angle:Number=0;
			if (null != skill_model)
			{
				var tarK:IGameKing=targetKing;
				if (skill_model.effect_turn2 == 0 && null != tarK)
				{
					var pA:Point=new Point(this.targetInfo.src_mapx, this.targetInfo.src_mapy);
					var pB:Point=new Point(tarK.x, tarK.y);
					angle=MapCl.getAngle(pB, pA);
				}
			}
			Two_Sub_RefreshFx(tarK);
			var playTime:int=SkillPlayTimeEnum.getSkillPlayTimeById(this.skill);
			var d:DisplayObject=SkillEffectManager.instance.getPool(this.skill, SKILL_EFFECT_X, skill_model.effect2, this.targetInfo.src_sex, this.targetInfo.srcid, angle - offsetAngle, null, playTime);
			if (null == d)
			{
				return;
			}
			this.addChild(d);
		}

		public function One_Sub_SysConfig(hasMe:Boolean=true, hasMePet:Boolean=true, hasMeMon:Boolean=true):void
		{
			if (hasMe)
			{
				if (this.isMe)
				{
					return;
				}
			}
			if (hasMePet)
			{
				if (this.isMePet)
				{
					return;
				}
			}
			if (hasMeMon)
			{
				if (this.isMeMon)
				{
					return;
				}
			}
			this.visible=!Action.instance.sysConfig.alwaysHideHumanAndPet;
		}

		/**
		 * 增加到人物身上
		 */
		public function Two_AddChild():void
		{
			Two_Sub_RefreshFx(targetKing);
			if (null == targetKing)
			{
//				var w:Number=this.width;
//				var h:Number=this.height;
//				var px:int = MapCl.gridXToMap(targetInfo.target_mapx);
//				var py:int = MapCl.gridYToMap(targetInfo.target_mapy);
//				this.x=px;
//				this.y=py;
//				SceneManager.instance.AddItem_Core(this);
				return;
			}
			else if ((targetKing.getSkin().getRole() == null && skill_model.attack_target_show == 1) || targetKing.getSkin().getRole() != null)
			{
				if (1 == skill_model.effect_floor2)
				{
					targetKing.getSkin().effectDown.addChild(this);
				}
				else
				{
					targetKing.getSkin().effectUp.addChild(this);
				}
				Two_Sub_Sound();
			}
		}

		/**
		 * 播放技能声音
		 */
		private function Two_Sub_Sound():void
		{
			if (skill_model.effect2 > 0)
			{
				if ((this.isMe || this.isMePet || this.isMeMon) || (null != this.targetInfo && this.targetInfo.targetid == Data.myKing.objid))
				{
					//2012-05-22 andy 播放技能声音
					MusicMgr.playWave(MusicDef.getSkillMusic(this.skill, SKILL_EFFECT_X));
//					if(null != targetKing)
//					{
//						this.targetKing.playSoundHurt();
//					}
				}
			}
		}

		/**
		 * 此函数只可在Two_AddChild里调用，
		 * 因为要对movie设playCount，别处一旦调用，可能会影响回调函数
		 * 即使不影响，也会提前调用回调函数，而导致效果提前结束
		 */
		private function Two_Sub_RefreshFx(k:IGameKing):void
		{
			var i:int;
			//调整方向
			var d:DisplayObject;
			var m_fx:String=getFx(k == null ? "F1" : k.roleFX);
			for (i=0; i < this.numChildren; i++)
			{
				d=this.getChildAt(i);
				if (d as ResMc)
				{
					MapCl.setFangXiang(d as ResMc, this.DZ, getFx(m_fx));
				}
				else if (d as SkinBySkill)
				{
					var effect_time:int=skill_model.effect_time2;
					if (effect_time == 0)
					{
						effect_time=SkillPlayTimeEnum.getSkillPlayTimeById(skill_model.effect2);
					}
					var pCount:int=effect_time == 0 ? 1 : (effect_time < 1500 ? 1 : 0);
					(d as SkinBySkill).setAction(this.DZ, getFx(m_fx), pCount, null);
				}
				SkillEffectManager.instance.AdjustBodyXY(d, skill_model.effect_pos2, this.targetInfo, SKILL_EFFECT_X, this.skill);
			} //end for			
		}

		/**
		 * 可看成是play
		 */
		public function Three_Move():void
		{
			var useTweenLite:Boolean=true;
			var srcK:IGameKing=this.srcKing;
			var targetK:IGameKing=this.targetKing;
			if (null == targetKing)
				return;
			//get time
//			if(FileManager.instance.isShortShortSkill(this.skill))
//			{
//				moveTime=SkillEffectManager.MOVE_TIME_MINMIN;
//			}else 
			if (FileManager.instance.isBasicSkillEffect(this.skill))
			{
				moveTime=SkillEffectManager.MOVE_TIME_MAX;
//				moveTime=SkillEffectManager.MOVE_TIME_MINMIN;
			}
			else
			{
				//0需要播一次，
				if (0 == skill_model.effect_time2 && this.hasSkinBySkillAndRoleLoaded && null != targetK)
				{
					useTweenLite=false;
				}
				else
				{
					useTweenLite=true;
					var effect_time:int=skill_model.effect_time2;
					if (effect_time == 0)
					{
						effect_time=SkillPlayTimeEnum.getSkillPlayTimeById(skill_model.effect2);
					}
					moveTime=effect_time / 1000;
				}
			}
			//check
			if (!isFinite(moveTime) || isNaN(moveTime) || 0 == moveTime)
			{
				moveTime=1.0;
			}
			if (moveTime > 3)
			{
				moveTime=3.0;
			}
//			useTweenLite=true;
			var d:DisplayObject;
			var i:int;
			//move
			if (useTweenLite)
			{
				TweenLite.to(this, moveTime, {onComplete: Four_MoveComplete});
				for (i=0; i < this.numChildren; i++)
				{
					d=this.getChildAt(i);
					if (d as SkinBySkill)
					{
//						(d as SkinBySkill).setAction(this.DZ, "F1",null,D_AS_MOVIE_PLAY_COUNT);
						MapCl.setFangXiang((d as SkinBySkill).getRole(), this.DZ, "F1", null, D_AS_MOVIE_PLAY_COUNT, Four_MoveComplete);
						//MapCl.setFangXiang((d as SkinBySkill).getRole(),this.DZ,GameKing.roleFX,null);
						break;
					}
				}
			}
			else
			{
				//----------------------------------------------------
				//设playCount
				//有一个设了就行
				for (i=0; i < this.numChildren; i++)
				{
					d=this.getChildAt(i);
					if (d as ResMc)
					{
						MapCl.setFangXiang(d as ResMc, this.DZ, getFx(targetK.roleFX), null, D_AS_MOVIE_PLAY_COUNT, Four_MoveComplete);
						//MapCl.setFangXiang(d as Movie,this.DZ,GameKing.roleFX,null);
						break;
					}
					else if (d as SkinBySkill)
					{
						(d as SkinBySkill).setAction(this.DZ, getFx(targetK.roleFX), D_AS_MOVIE_PLAY_COUNT, Four_MoveComplete);
						MapCl.setFangXiang((d as SkinBySkill).getRole(), this.DZ, getFx(targetK.roleFX), null, D_AS_MOVIE_PLAY_COUNT, Four_MoveComplete);
						//MapCl.setFangXiang((d as SkinBySkill).getRole(),this.DZ,GameKing.roleFX,null);
						break;
					}
				}
				//为保证删除
				//10秒改为7秒
				TweenLite.delayedCall(2, Four_MoveComplete);
				delayCallFour=true;
					//-------------------------------------------------------
			}
//			if (this.numChildren>0)//当前特效释放有效 此處的判斷需要在特殊情況下驗證一下，應該是因為bug添加的
//			{
//				if (targetK!=null)
//					(targetK as King).hit();
//			}
//				if (targetK.isMe)
//				{
//					(targetK as King).hit();
//				}
//				else
//				{
//					var action:ActionHit = new  ActionHit();
//					(targetK as King).postAction(action);
//				}
			//击退
			if (null == srcK || null == targetK || false == this.driveOff)
			{
				return;
			}
			if (targetK.name2.indexOf(BeingType.HUMAN) >= 0)
			{
				return;
			}
			if (false == targetK.canDriveOff)
			{
				return;
			}
			//return;
			var bezierX:int;
			var bezierY:int;
			var bezierX2:int;
			var bezierY2:int;
			var tP:Point=new Point(targetK.mapx, targetK.mapy);
			var srcK_Fx:String=srcK.roleFX;
			//
			if (srcK.mapx <= targetK.mapx && srcK.mapy <= targetK.mapy)
			{
				if ("F8" == srcK_Fx)
				{
					bezierX=targetK.x + driveOffDistanceX;
					bezierY=targetK.y + driveOffDistanceY;
					bezierX2=bezierX + 90; //80;
					bezierY2=bezierY + 40; //30;
					tP.x=bezierX2;
					tP.y=bezierY2 + driveOffDistanceY;
				}
				else
				{
					bezierX=targetK.x + driveOffDistanceX;
					bezierY=targetK.y - driveOffDistanceY;
					bezierX2=bezierX + 90; //80;
					bezierY2=bezierY + 40; //30;
					tP.x=bezierX2;
					tP.y=bezierY2 + driveOffDistanceY;
				}
			}
			else if (srcK.mapx >= targetK.mapx && srcK.mapy >= targetK.mapy)
			{
				if ("F2" == srcK_Fx || "F3" == srcK_Fx || "F4" == srcK_Fx)
				{
					bezierX=targetK.x - driveOffDistanceX;
					bezierY=targetK.y - driveOffDistanceY;
					bezierX2=bezierX - 90; //80;
					bezierY2=bezierY + 40; //30;
					tP.x=bezierX2;
					tP.y=bezierY2 + driveOffDistanceY;
				}
				else
				{
					bezierX=targetK.x - driveOffDistanceX;
					bezierY=targetK.y + driveOffDistanceY;
					bezierX2=bezierX - 90; //80;
					bezierY2=bezierY - 40; //30;
					tP.x=bezierX2;
					tP.y=bezierY2 + driveOffDistanceY;
				}
			}
			else if (srcK.mapx <= targetK.mapx && srcK.mapy >= targetK.mapy)
			{
				if ("F5" == srcK_Fx || "F6" == srcK_Fx || "F7" == srcK_Fx || "F8" == srcK_Fx || "F1" == srcK_Fx)
				{
					bezierX=targetK.x + driveOffDistanceX;
					bezierY=targetK.y - driveOffDistanceY;
					bezierX2=bezierX + 90; //80;
					bezierY2=bezierY + 40; //30;
					tP.x=bezierX2;
					tP.y=bezierY2 + driveOffDistanceY;
				}
				else
				{
					bezierX=targetK.x - driveOffDistanceX;
					bezierY=targetK.y - driveOffDistanceY;
					bezierX2=bezierX - 90; //80;
					bezierY2=bezierY + 40; //30;
					tP.x=bezierX2;
					tP.y=bezierY2 + driveOffDistanceY;
				}
			}
			else if (srcK.mapx >= targetK.mapx && srcK.mapy <= targetK.mapy)
			{
				bezierX=targetK.x - driveOffDistanceX;
				bezierY=targetK.y - driveOffDistanceY;
				bezierX2=bezierX - 90; //80;
				bezierY2=bezierY + 40; //30;
				tP.x=bezierX2;
				tP.y=bezierY2 + driveOffDistanceY;
			}
			else
			{
				bezierX=targetK.x - driveOffDistanceX;
				bezierY=targetK.y - driveOffDistanceY;
				bezierX2=bezierX - 90; //80;
				bezierY2=bezierY + 40; //30;
				tP.x=bezierX2;
				tP.y=bezierY2 + driveOffDistanceY;
			}
			//
			if (3 == driveOffMode)
			{
				TweenMax.to(targetKing, driveOffTime, {x: tP.x, y: tP.y, bezierThrough: [{x: bezierX, y: bezierY}, {x: bezierX2, y: bezierY2}], ease: Linear.easeNone});
			}
			else if (2 == driveOffMode)
			{
				TweenMax.to(targetKing, driveOffTime, {x: tP.x, y: tP.y, bezierThrough: [{x: bezierX, y: bezierY}, {x: bezierX2, y: bezierY2}], ease: Linear.easeInOut});
			}
			else if (1 == driveOffMode)
			{
				TweenMax.to(targetKing, driveOffTime, {x: tP.x, y: tP.y, bezierThrough: [{x: bezierX, y: bezierY}, {x: bezierX2, y: bezierY2}], ease: Linear.easeOut});
			}
			else
			{
				TweenMax.to(targetKing, driveOffTime, {x: tP.x, y: tP.y, bezierThrough: [{x: bezierX, y: bezierY}, {x: bezierX2, y: bezierY2}], ease: Linear.easeIn});
			}
		}

		/**
		 * 飘血
		 */
		public function Four_MoveComplete():void
		{
			//Debug.instance.traceMsg("Four_MoveComplete");
			if (delayCallFour)
			{
//				TweenLite.killTweensOf(Four_MoveComplete);
				TweenLite.killTweensOf(this, true);
			}
			//
			clear();
		}

		public function clear():void
		{
			var len:int=this.numChildren;
			var d:DisplayObject;
			for (var i:int=0; i < len; i++)
			{
				d=this.removeChildAt(0);
				if (d as SkinBySkill)
				{
					(d as SkinBySkill).removeAll();
				}
				else if (d as ResMc)
				{
//					(d as Movie).playOverAct=null;
					//(d as Movie).stop();
					(d as ResMc).close();
				}
			}
			//
			if (null != this.parent)
			{
				this.parent.removeChild(this);
			}
		}

		public function get hasSkinBySkillAndRoleLoaded():Boolean
		{
			//loop use
			var i:int;
			//调整方向
			var d:DisplayObject;
			for (i=0; i < this.numChildren; i++)
			{
				d=this.getChildAt(i);
				if (d as SkinBySkill)
				{
					if (null != (d as SkinBySkill).getRole())
					{
						return true;
					}
				}
				if (d as ResMc)
				{
					return true;
				}
			} //end for
			return false;
		}

		public function get srcKing():IGameKing
		{
			return SceneManager.instance.GetKing_Core(targetInfo.srcid);
		}

		public function get targetKing():IGameKing
		{
			return SceneManager.instance.GetKing_Core(targetInfo.targetid);
		}

		public function DelHitArea():void
		{
			//
		}

		public function UpdHitArea():void
		{
			//
		}
	}
}
