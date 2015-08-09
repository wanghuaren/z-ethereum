package scene.skill2
{
	import com.bellaxu.def.DepthDef;
	import com.bellaxu.def.MusicDef;
	import com.bellaxu.mgr.MusicMgr;
	import com.bellaxu.res.ResMc;
	import com.greensock.TweenLite;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SkillResModel;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import netc.Data;
	
	import scene.action.Action;
	import scene.event.KingActionEnum;
	import scene.king.IGameKing;
	import scene.king.SkinBySkill;
	import scene.king.TargetInfo;
	import scene.manager.SceneManager;
	import scene.utils.MapCl;
	
	import world.FileManager;
	import world.graph.WorldSprite;

	/**
	 * 与SkillEffect3的区别是3是飞到后消失，
	 * 4是直接飞到后原地播动画后消失
	 *
	 */
	public class SkillEffect31 extends WorldSprite implements ISkillEffect
	{
		public function DelHitArea():void
		{
			//
		}

		public function UpdHitArea():void
		{
			//
		}

		public static const SKILL_EFFECT_X:int=4;

		/**
		 * 内容的默认播放次数
		 */
		public static const D_AS_MOVIE_PLAY_COUNT:int=1; //10;//1;

		private var _fx:String="F1";

		public function get DZ():String
		{
			//return KingActionEvent.PuTong_DaiJi;
			return KingActionEnum.GJ;
		}

		public function get skill_model():Object
		{
	//项目转换		return Lib.getObj(LibDef.PUB_SKILL, skill.toString());
			return XmlManager.localres.getSkillXml.getResPath(skill);
		}
		private var offsetAngle:int=0;

		public function getFx(k_roleFX:String):String
		{
			//Skill_400014 F1 
//项目转换			var m:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, skill.toString());
			var m:Pub_SkillResModel = XmlManager.localres.getSkillXml.getResPath(skill) as Pub_SkillResModel;
			var m_info:Array=SkillEffectManager.instance.getFXAndAngle(m["effect_fx" + SKILL_EFFECT_X], m["effect_turn" + SKILL_EFFECT_X]);
			if (m_info[0] != null)
				k_roleFX=m_info[0];
			offsetAngle=m_info[1];
			return k_roleFX;
		}

		public function get FX():String
		{
			return _fx;
		}

		public function set FX(value:String):void
		{
			_fx=getFx(value);
		}
		/**
		 * 技能资源ID
		 */
		private var m_nSkillModelId:int;
		
		public function get skillModelId():int
		{
			return m_nSkillModelId;
		}
		public var skill:int;
		public var targetInfo:TargetInfo;

		public var d_as_Movie:Boolean;
		public var d_height:int;

		//
		public var moveTime:Number;

		public var tOut:uint;

		public function SkillEffect31(objid_:uint)
		{
			this.objid=objid_;
		}


		public function init():void
		{
			this.mouseEnabled=this.mouseChildren=false;
			d_as_Movie=false;
			d_height=10;
			_fx="F1";
			this.visible=true;
			tOut = 0;
			
			this.depthPri = DepthDef.TOP;
		}

		public function setData(skill_:int, targetInfo_:TargetInfo):void
		{
			this.m_nSkillModelId = this.skill=skill_;

			this.targetInfo=targetInfo_.clone();

			//test

		/*this.graphics.clear();
		this.graphics.beginFill(0x001100);
		this.graphics.drawRect(0,0,50,50);
		this.graphics.endFill();*/

		}

		public function get target_info():TargetInfo
		{
			return this.targetInfo;
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

			//飞行
	//项目转换		var m:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, skill.toString());
			var m:Pub_SkillResModel = XmlManager.localres.getSkillXml.getResPath(skill) as Pub_SkillResModel;
			//特殊处理，如effect4为0，查skill_Special表
			var effectX_value:int=m["effect" + SKILL_EFFECT_X.toString()];

			if (0 == effectX_value)
			{
				//没有用
//				var instance_id:int = parseInt(skill.toString() + "00");
//				var model_data:Pub_Skill_DataResModel = GameData.getPubSkillDataXml().getResPath(instance_id);
//				var model_special:Pub_Skill_SpecialResModel = XmlManager.instance.localres.SkillSpecialXml.getResPath(model_data.logic_id);
//				
//				effectX_value = model_special.logic_id;
			}

			var playTime:int = SkillPlayTimeEnum.getSkillPlayTimeById(this.skill);
			var d:DisplayObject=SkillEffectManager.instance.getPool(this.skill, SKILL_EFFECT_X, effectX_value, this.targetInfo.src_sex, this.targetInfo.srcid,0,null,playTime);

			if (null == d)
			{
				//飞行元件不可为null
				throw new Error("SkillEffect " + SKILL_EFFECT_X.toString() + ": d can not be null");
			}

			//
			var pA:Point=new Point(this.targetInfo.src_mapx, this.targetInfo.src_mapy);
			var pB:Point=new Point(this.targetInfo.target_mapx, this.targetInfo.target_mapy);

			var angle:int=MapCl.getAngle(pB, pA);




			//
			if (!FileManager.instance.isBasicSkillEffect(this.skill))
			{
				//var mo:Movie = d as Movie;

				//F1
				//地面上的不需要变方向
				//var fx:String = "F1";
				this.FX=MapCl.getWASD(angle);

				if (d as ResMc)
				{
					MapCl.setFangXiang((d as ResMc), this.DZ, this.FX, null);

				}
				else if (d as SkinBySkill)
				{
					var pCount:int = m.effect_time4==0?1:(m.effect_time4>1000?0:1);
					(d as SkinBySkill).setAction(this.DZ, this.FX ,pCount);
				}
				//if(null != mo)
				if (d as ResMc)
				{
					d_as_Movie=true;
					d_height=(d as ResMc).height;
				}
			}
			this.addChild(d);
			this.rotation=offsetAngle;
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
		 * 增加到屏幕
		 */
		public function Two_AddChild():void
		{
			var w:Number=this.width;
			var h:Number=this.height;

//项目转换			var skill_model:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, skill.toString());
			var skill_model:Pub_SkillResModel = XmlManager.localres.getSkillXml.getResPath(skill) as Pub_SkillResModel;
			//未加载完时的坐标修正
			if (0 == w && 0 == h)
			{
				if ("400001" == skill_model["effect" + SKILL_EFFECT_X.toString()].toString())
				{
					w=SkillEffectManager.SKILL_400001_WIDTH;
					h=SkillEffectManager.SKILL_400001_HEIGHT;
				}

			} //end if

			//var p:Point = SkillEffectManager.instance.AdjustStartMapXY(this.SKILL_EFFECT_X,this.targetInfo,w,h);

			//确定终点前校正一下终点坐标			
			//这里与SkillEffect3不同，是Two
			Two_Sub_EndMapXYOffset();

			//			
			var p:Point;

//			if (this.d_as_Movie)
//			{
			p=SkillEffectManager.instance.AdjustEndMapXYByEffect31Foot(this.targetInfo, w, this.d_height, this.d_as_Movie, this.skill, skill_model);

//			}
//			else
//			{
//				p=SkillEffectManager.instance.AdjustEndMapXYByEffect31Foot(this.targetInfo, w, h, this.d_as_Movie, this.skill);
//			}

			this.x=p.x;
			this.y=p.y
//			if (skill_model.select_type == 2)
//			{
//				targetInfo.targetid = 0;
//			}
			//
			//this.targetInfo.
			if ([0, 1, 2].indexOf(skill_model.select_type) >= 0 && targetInfo.targetid != 0)
			{
			}
			else
			{
				SceneManager.instance.AddItem_Core(this);
			}
//			SceneManager.instance.AddItem_Core(this);
			//
			Two_Sub_Sound();
		}

		/**
		 * 播放技能声音
		 */
		private function Two_Sub_Sound():void
		{
			if(this.isMe || this.isMePet || this.isMeMon)
			{
				//肯定有声音，不用加判断
				//2012-05-22 andy 播放技能声音
				MusicMgr.playWave(MusicDef.getSkillMusic(this.skill, SKILL_EFFECT_X));
			}
		}

		/**
		 *  飞行方向在中途不需要纠正
		 * 本类不需要Two_Sub_RefreshFx函数
		 */

		/**
		 * 移动
		 */
		public function Three_Move():void
		{
			var useTweenLite:Boolean=true;

			//get time
			if (FileManager.instance.isBasicSkillEffect(this.skill))
			{
				moveTime=SkillEffectManager.MOVE_TIME_MAX;

			}
			else
			{
				//读表
		//项目转换		var model:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, this.skill.toString());
				var model:Pub_SkillResModel = XmlManager.localres.getSkillXml.getResPath(skill) as Pub_SkillResModel;
				//0需要播一次，
				if (0 == model["effect_time" + SKILL_EFFECT_X.toString()] && this.hasSkinBySkillAndRoleLoaded)
				{
					useTweenLite=false;
				}
				else
				{
					useTweenLite=true

					moveTime=model["effect_time" + SKILL_EFFECT_X.toString()] / 1000;

				}
			}

			//check
			if (!isFinite(moveTime) || isNaN(moveTime) || 0 == moveTime)
			{
				moveTime=1.0;
			}

			//move
			if (useTweenLite)
			{
				TweenLite.to(this, moveTime, {onComplete: Four_MoveComplete});
			}
			else
			{
				//----------------------------------------------------
				
				tOut = flash.utils.setTimeout(Four_MoveComplete,3500);
				
				
				//设playCount
				//有一个设了就行
				var d:DisplayObject;
				var i:int;

				for (i=0; i < this.numChildren; i++)
				{
					d=this.getChildAt(i);

					if (d as ResMc)
					{
						MapCl.setFangXiang(d as ResMc, this.DZ, this.FX, null, D_AS_MOVIE_PLAY_COUNT, Four_MoveComplete);
						//MapCl.setFangXiang(d as Movie,this.DZ,GameKing.roleFX,null);

						break;

					}
					else if (d as SkinBySkill)
					{
						MapCl.setFangXiang((d as SkinBySkill).getRole(), this.DZ, this.FX, null, D_AS_MOVIE_PLAY_COUNT, Four_MoveComplete);
						//MapCl.setFangXiang((d as SkinBySkill).getRole(),this.DZ,GameKing.roleFX,null);
						break;
					}
				}
			}
		}

		/**
		 * 飘血
		 */
		public function Four_MoveComplete():void
		{
			if(tOut > 0)
			{
				flash.utils.clearTimeout(tOut);
			}
			TweenLite.killTweensOf(this,true);
			//Debug.instance.traceMsg("Four_MoveComplete");
//			WaftNumManager.instance.showTrail(this.target_info.targetid);
			Action.instance.fight.CFightInstant_Complete(this.targetInfo, this.skill);
//			SkillTrackReal.instance.mapObjStatus(this.target_info.targetid);
			//
			clear();
		}

		/**
		 * 校正终点位置
		 * 这里与SkillEffect3不同，是Two
		 */
		private function Two_Sub_EndMapXYOffset():void
		{
			var GameKing:IGameKing=SceneManager.instance.GetKing_Core(targetInfo.targetid);

			if (null == GameKing)
			{
				return;
			}

			//偏移量不能超过400，以免引起跨屏错误,而且人物还要换方向
			//由于人跑得较快，现改成500
			if (Math.abs(this.targetInfo.target_mapx - GameKing.mapx) < 750 && Math.abs(this.targetInfo.target_mapy - GameKing.mapy) < 750)
			{
				this.targetInfo.target_mapx=GameKing.mapx;
				this.targetInfo.target_mapy=GameKing.mapy;
			}
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
					//(d as Movie).stop();
					(d as ResMc).close();
				}
			}
			//====whr==========
			d=null;
			//
			if (null != this.parent)
			{
				this.parent.removeChild(this);
			}
		}

		//get
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

		public function get skill_effect_pos():int
		{
	//项目转换		var model:Pub_SkillResModel = Lib.getObj(LibDef.PUB_SKILL, skill.toString());
			var model:Pub_SkillResModel = XmlManager.localres.getSkillXml.getResPath(skill) as Pub_SkillResModel;
			return model["effect_pos" + SKILL_EFFECT_X.toString()];
		}

		public function get srcKing():IGameKing
		{
			var GameKing:IGameKing=SceneManager.instance.GetKing_Core(targetInfo.srcid);

			return GameKing;
		}

		public function get targetKing():IGameKing
		{
			var GameKing:IGameKing=SceneManager.instance.GetKing_Core(targetInfo.targetid);

			return GameKing;
		}


	}
}
