package scene.skill2
{
	import com.bellaxu.def.DepthDef;
	import com.bellaxu.def.MusicDef;
	import com.bellaxu.mgr.MusicMgr;
	import com.bellaxu.res.ResMc;
	import com.greensock.TweenLite;
	import common.config.xmlres.XmlManager;
	import flash.display.DisplayObject;
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
	import world.graph.WorldSprite;

	/**
	 * 与3不同，此类继承sprite即可
	 */
	public class SkillEffect1 extends WorldSprite implements ISkillEffect
	{
		public function DelHitArea():void
		{
			//
		}

		public function UpdHitArea():void
		{
			//
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
		/**
		 * 自己身上特效
		 * */
		public static const SKILL_EFFECT_X:int=1;
		/**
		 * 内容的默认播放次数
		 */
		public static const D_AS_MOVIE_PLAY_COUNT:int=1;

		public function get DZ():String
		{
			return KingActionEnum.GJ;
		}
		private var offsetAngle:int=0;

		public function getFx(k_roleFX:String):String
		{
			var m_info:Array=SkillEffectManager.instance.getFXAndAngle(skill_model.effect_fx1, skill_model.effect_turn1);
			if (m_info[0] != null)
				k_roleFX=m_info[0];
			offsetAngle=m_info[1];
			return k_roleFX;
		}

		public function get skill_model():Object
		{
			if (extraData != null)
			{
				return extraData;
			}
			//项目转换	return Lib.getObj(LibDef.PUB_SKILL, skill.toString());
			return XmlManager.localres.getSkillXml.getResPath(skill);
		}
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
		public var extraData:Object;
		//
		public var moveTime:Number;

		public function SkillEffect1()
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
			this.depthPri=DepthDef.NORMAL;
		}

		public function setData(skill_:int, targetInfo_:TargetInfo, _extraData:Object=null):void
		{
			this.m_nSkillModelId=this.skill=skill_;
			this.targetInfo=targetInfo_.clone();
			this.extraData=_extraData;
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
		private var angle:Number=0;

		/**
		 * 创建效果文件
		 */
		public function One_CreateEffect():void
		{
			if (!srcKing || !this.targetInfo)
				return;
			One_Sub_SysConfig();
			var kingRoleFX:String=srcKing.roleFX;
			if (skill_model.effect_turn1 == 0)
			{
				var pA:Point=new Point(this.targetInfo.src_mapx, this.targetInfo.src_mapy);
				var pB:Point=new Point(this.targetInfo.target_mapx, this.targetInfo.target_mapy);
				angle=MapCl.getAngle(pB, pA);
				if (this.skill == 401207 || this.skill == 401103 || this.skill == 401101)
				{
					angle=MapCl.getSpecialSkillAngle(kingRoleFX);
				}
			}
			Two_Sub_RefreshFx(srcKing);
			if (extraData != null)
			{
				this.skill=extraData.effect1;
			}
			var playTime:int=SkillPlayTimeEnum.getSkillPlayTimeById(this.skill);
			var d:DisplayObject=SkillEffectManager.instance.getPool(this.skill, skill_model.effect_fx1, skill_model.effect1, this.targetInfo.src_sex, this.targetInfo.srcid, angle - offsetAngle, kingRoleFX, playTime);
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
			//变身状态下取消特定自身特效
			if (this.visible)
			{
				this.visible=checkEffectVisibleForBianShen();
			}
		}
		private var skillResIdForBianShen:Array=[401207, 401202, 401208];

		private function checkEffectVisibleForBianShen():Boolean
		{
			var result:Boolean=true;
			if (MapCl.isBianShen(srcKing.s2))
			{
				if (srcKing.metier == 1)
				{
					result=false;
				}
				else if (skillResIdForBianShen.indexOf(skill) != -1)
				{
					result=false;
				}
			}
			return result;
		}
		private var skillPoint:Point=new Point();

		/**
		 * 增加到人物身上
		 */
		public function Two_AddChild():void
		{
			if (null == srcKing)
			{
				return;
			}
			Two_Sub_RefreshFx(srcKing);
			if (1 == skill_model.effect_floor1)
			{
				srcKing.getSkin().foot.addChild(this);
			}
			else
			{
				if (srcKing.roleFX == "F5")
				{
					srcKing.getSkin().foot.addChild(this);
				}
				else
				{
					srcKing.getSkin().effectUp.addChild(this);
				}
			}
			Two_Sub_Sound();
		}

		/**
		 * 播放技能声音
		 */
		private function Two_Sub_Sound():void
		{
			if (skill_model.effect1 > 0)
			{
				if ((this.isMe || this.isMePet || this.isMeMon) || (null != this.targetInfo && this.targetInfo.targetid == Data.myKing.objid))
				{
					//2012-05-22 andy 播放技能声音
					MusicMgr.playWave(MusicDef.getSkillMusic(this.skill, SKILL_EFFECT_X));
				}
			}
		}

		/**
		 * 此函数只可在Two_AddChild里调用，
		 * 因为要对movie设playCount，别处一旦调用，可能会影响回调函数
		 * 即使不影响，也会提前调用回调函数，而导致效果提前结束
		 *
		 * effectPos 1脚下 2胸前 3头顶
		 */
		private function Two_Sub_RefreshFx(k:IGameKing):void
		{
			//loop use
			var i:int;
			//调整方向
			var d:DisplayObject;
			var m_fx:String=getFx(k.roleFX);
			for (i=0; i < this.numChildren; i++)
			{
				d=this.getChildAt(i);
				if (d as ResMc)
				{
					MapCl.setFangXiang(d as ResMc, this.DZ, getFx(m_fx));
				}
				else if (d as SkinBySkill)
				{
					(d as SkinBySkill).setAction(this.DZ, getFx(m_fx), D_AS_MOVIE_PLAY_COUNT, null);
				}
				SkillEffectManager.instance.AdjustBodyXY(d, skill_model.effect_pos1, this.targetInfo, SKILL_EFFECT_X, this.skill);
				if (skill_model.effect_fx1 == 0)
				{
					switch (m_fx)
					{
						case "F5":
							var pArray:Array=skill_model.effect_pos1.split(",");
							d.y+=int(pArray[5]);
							break;
					}
				}
			} //end for			
		}

		/**
		 * 可看成是play
		 */
		public function Three_Move():void
		{
			//
			var useTweenLite:Boolean=true;
			//get time
			if (FileManager.instance.isBasicSkillEffect(this.skill))
			{
				moveTime=SkillEffectManager.MOVE_TIME_MAX;
			}
			else
			{
				//0需要播一次，
				//if(0 == model.effect_time1 && 
				if (0 == skill_model.effect_time1 && null != srcKing)
				{
					useTweenLite=false;
				}
				else
				{
					useTweenLite=true
					moveTime=skill_model.effect_time1 / 1000;
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
				TweenLite.to(this, 5.0, {onComplete: Four_MoveComplete});
				//----------------------------------------------------
				//设playCount
				//有一个设了就行
//				
				var i:int;
				var d:DisplayObject;
				for (i=0; i < this.numChildren; i++)
				{
					d=this.getChildAt(i);
					if (d as ResMc)
					{
						MapCl.setFangXiang(d as ResMc, this.DZ, getFx(srcKing.roleFX), null, D_AS_MOVIE_PLAY_COUNT, Four_MoveComplete);
//						skillMovie=d as ResMc;
						break;
					}
					else if (d as SkinBySkill)
					{
						(d as SkinBySkill).setAction(this.DZ, getFx(srcKing.roleFX), D_AS_MOVIE_PLAY_COUNT, Four_MoveComplete);
//						skillMovie=(d as SkinBySkill).getRole();
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
			//Debug.instance.traceMsg("Four_MoveComplete");
			TweenLite.killTweensOf(this, true);
			clear();
		}

		public function clear():void
		{
			extraData=null;
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
				if (d as ResMc)
				{
					return true;
				}
				else if (d as SkinBySkill)
				{
					if (null != (d as SkinBySkill).getRole())
					{
						return true;
					}
				}
			} //end for
			return false;
		}

		public function get srcKing():IGameKing
		{
			return SceneManager.instance.GetKing_Core(targetInfo.srcid);
		}
	}
}
