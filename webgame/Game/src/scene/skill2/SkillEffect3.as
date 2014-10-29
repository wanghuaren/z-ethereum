package scene.skill2
{
	import com.bellaxu.def.DepthDef;
	import com.bellaxu.def.MusicDef;
	import com.bellaxu.mgr.MusicMgr;
	import com.bellaxu.res.ResMc;
	import com.greensock.TweenLite;
	import com.greensock.easing.Linear;
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SkillResModel;
	import common.utils.graph.MatrixTransformer;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
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
	import world.WorldFactory;
	import world.graph.WorldSprite;

	/**
	 * 与SkillEffect3的区别是3是飞到后消失，
	 * 4是直接飞到后原地播动画后消失
	 *
	 */
	public class SkillEffect3 extends WorldSprite implements ISkillEffect
	{
		public function DelHitArea():void
		{
			//
		}

		public function UpdHitArea():void
		{
			//
		}
		/**
		 * 轨迹特效
		 * */
		public static const SKILL_EFFECT_X:int=3;
		private var _fx:String="F1";

		public function get DZ():String
		{
			return KingActionEnum.GJ;
		}

		public function get skill_model():Pub_SkillResModel
		{
//项目转换		return Lib.getObj(LibDef.PUB_SKILL, skill.toString());
			return XmlManager.localres.getSkillXml.getResPath(skill) as Pub_SkillResModel;
		}
		private var offsetAngle:int=90;

		public function getFx(k_roleFX:String):String
		{
			//Skill_400014 F1 
			var m_info:Array=SkillEffectManager.instance.getFXAndAngle(skill_model.effect_fx3, skill_model.effect_turn3);
			if (m_info[0] != null)
				k_roleFX=m_info[0];
			offsetAngle=m_info[1];
			if (skill_model.effect3 == 4012011)
			{
				offsetAngle=180;
			}
			return k_roleFX;
		}

		public function get FX():String
		{
			return "F1";
		}

		public function get has5Fx():Boolean
		{
			var c:int=skill_model.effect_fx3;
			if (1 == c)
			{
				return false;
			}
			return true;
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
		public var d_as_Shape:Boolean;

		//这里不用申明moveTime变量
		//飞行时间一般0.2-0.3秒，在skillManager中MOVE_TIME_MAX有指定
		public function SkillEffect3(objid_:uint)
		{
			this.objid=objid_;
		}

		public function init():void
		{
			this.x=0;
			this.y=0;
			this.mouseEnabled=this.mouseChildren=false;
			d_as_Movie=false;
			this.d_as_Shape=false;
			_fx="F1";
			this.visible=true;
			angle=0;
			this.depthPri=DepthDef.TOP;
			this.rotation=0;
			origin_w_movie=0;
			origin_h_movie=0;
			origin_w_mc=0;
			origin_h_mc=0;
			origin_x=0;
			origin_y=0;
			this.skill=0;
			this.targetInfo=null;
			//
			this.removeEventListener(Event.REMOVED_FROM_STAGE, WorldFactory.SKILL_EF_3_REMOVED_FROM_STAGE);
			this.clear();
			this.addEventListener(Event.REMOVED_FROM_STAGE, WorldFactory.SKILL_EF_3_REMOVED_FROM_STAGE);
		}

		public function setData(skill_:int, targetInfo_:TargetInfo):void
		{
			this.m_nSkillModelId=this.skill=skill_;
			this.targetInfo=targetInfo_.clone();
			//test
		/*this.graphics.clear();
		this.graphics.beginFill(0x001100);
		this.graphics.drawRect(0,0,10,10);
		this.graphics.endFill();*/
		}
		/**
		 * 创建效果文件
		 */
		public var angle:int;
		/**
		 * 旋转
		 */
		public var origin_w_movie:Number;
		public var origin_h_movie:Number;
		public var origin_w_mc:Number;
		public var origin_h_mc:Number;
		public var origin_x:Number;
		public var origin_y:Number;

		// 技能名称  耀天诀 Pre_400016(资源) skill_id	401102
		public function One_CreateEffect():void
		{
			One_Sub_SysConfig();
			//飞行
			var playTime:int=SkillPlayTimeEnum.getSkillPlayTimeById(this.skill);
			var d:DisplayObject=SkillEffectManager.instance.getPool(this.skill, SKILL_EFFECT_X, skill_model.effect3, this.targetInfo.src_sex, this.targetInfo.srcid, 0, null, playTime);
			//test
			//var d:DisplayObject  = GamelibS.getswflink("tong_yong","SkillTest");
			if (null == d)
			{
				//飞行元件不可为null
				throw new Error("SkillEffect " + SKILL_EFFECT_X.toString() + ": d can not be null");
			}
			if ("0" == d.name)
			{
				d_as_Shape=true;
			}
			//
			var pA:Point=new Point(this.targetInfo.src_mapx, this.targetInfo.src_mapy);
			var pB:Point=new Point(this.targetInfo.target_mapx, this.targetInfo.target_mapy);
			var isNear:Boolean=SkillEffectManager.instance.adjustSkillStartFlyPosition(pA, pB);
			if (isNear)
				return;
			MapCl.gridToMap(pA);
			MapCl.gridToMap(pB);
			//var angle:int = MapCl.getAngle(pB,pA);
			angle=MapCl.getAngle(pB, pA);
			//
			var mo:ResMc;
			if ((!FileManager.instance.isBasicSkillEffect(this.skill) || "401002" == this.skill.toString()) && !d_as_Shape)
			{
				mo=d as ResMc;
				d_as_Movie=true;
				if (null != mo)
				{
					//如果在此stop，下面的setFangXiang不起作用
					//mo.gotoAndStop("D3F1");
				}
				//play
				var srcK:IGameKing=srcKing;
				var playCount:int=0;
				if (!has5Fx)
				{
					if (d as ResMc)
					{
						MapCl.setFangXiang(mo, this.DZ, this.FX, null);
					}
					else if (d as SkinBySkill)
					{
						(d as SkinBySkill).setAction(this.DZ, this.FX, playCount, null);
					}
				}
				else
				{
					if (null == srcK)
					{
						if (d as ResMc)
						{
							MapCl.setFangXiang(mo, this.DZ, this.FX, null);
						}
						else if (d as SkinBySkill)
						{
							(d as SkinBySkill).setAction(this.DZ, this.FX, playCount, null);
						}
					}
					else
					{
						if (d as ResMc)
						{
							MapCl.setFangXiang(mo, this.DZ, this.getFx(srcK.roleFX), null);
						}
						else if (d as SkinBySkill)
						{
							(d as SkinBySkill).setAction(this.DZ, this.getFx(srcK.roleFX), playCount, null);
						}
					}
				}
				//与下面是反的
				//实际值是0
				//写死
				if (null != mo)
				{
					origin_w_movie=mo.width;
					origin_h_movie=mo.height;
				}
				else
				{
					origin_w_movie=SkillEffectManager.instance.getMovieFirstFrameWidth(this.skill, SKILL_EFFECT_X)
					origin_h_movie=SkillEffectManager.instance.getMovieFirstFrameHeight(this.skill, SKILL_EFFECT_X);
				}
				this.addChild(d);
			}
			else
			{
				this.addChild(d);
				origin_w_mc=this.width;
				origin_h_mc=this.height;
			}
			var sw:int=this.width;
			var sh:int=this.height;
			var distance:Number=Point.distance(pA, pB);
			var tx:int=0;
			var ty:int=0;
			var effect3:int=skill_model.effect3;
			if (effect3 == 4013031 || effect3 == 4013041 || effect3 == 4012011)
			{ //施毒术、火灵符、大火球
				if (effect3 == 4013031)
				{
					sw=177;
					sh=60;
				}
				else if (effect3 == 4013041)
				{
					sw=133;
					sh=27;
				}
				else if (effect3 == 4012011)
				{
					sw=129;
					sh=88;
				}
				var radius:Number=(angle - 90) / 180 * Math.PI;
				tx=sw * Math.cos(radius) * 0.5;
				ty=sw * Math.sin(radius) * 0.5;
			}
			this.x=origin_x=pA.x - tx;
			this.y=origin_y=pA.y - ty;
			SkillEffectManager.instance.AdjustBodyXY(d, skill_model.effect_pos3, this.targetInfo, SKILL_EFFECT_X, this.skill);
//			SkillEffectManager.instance.AdjustBodyXY(d, "0,20", this.targetInfo, SKILL_EFFECT_X, this.skill);
			if (skill_model.effect_turn3 != 1)
			{
				if (effect3 == 4012011){
					d.rotation=angle - offsetAngle+90;
				}else{
					d.rotation=angle - offsetAngle;
				}
			}
		}

		/**
		 * 增加到屏幕
		 */
		public function Two_AddChild():void
		{
			var w:Number=this.width;
			var h:Number=this.height;
			//未加载完时的坐标修正
			if (0 == w && 0 == h)
			{
				if (400001 == skill_model.effect3)
				{
					w=SkillEffectManager.SKILL_400001_WIDTH;
					h=SkillEffectManager.SKILL_400001_HEIGHT;
				}
			} //end if
			//refresh x and y
			var GameKing:IGameKing=srcKing;
			if (null != GameKing)
			{
				this.targetInfo.src_mapx=GameKing.mapx;
				this.targetInfo.src_mapy=GameKing.mapy;
			}
			//			
//			this.x=origin_x=MapCl.gridXToMap(this.targetInfo.src_mapx);
//			this.y=origin_y=MapCl.gridYToMap(this.targetInfo.src_mapy); //- (this.targetInfo.src_height + this.height) / 2;
			//优化，这个只需计时就可以了
			if (!d_as_Shape)
			{
				SceneManager.instance.AddItem_Core(this);
			}
			//
			Two_Sub_Sound();
		}

		public function Two_Sub_Rotate(deg:Number):void
		{
			//原始x,y			
			var mat:Matrix=new Matrix(1, 0, 0, 1, this.origin_x, this.origin_y);
			//原始w,h
			//var blueRotCenter:Point = new Point(this.origin_w/2,this.origin_h/2);	
			var blueRotCenter:Point=new Point(0, 0);
			MatrixTransformer.rotateAroundInternalPoint(mat, blueRotCenter.x, blueRotCenter.y, deg);
			this.transform.matrix=mat;
		}

		/**
		 * 播放技能声音
		 */
		private function Two_Sub_Sound():void
		{
			if (skill_model.effect3 > 0)
			{
				if ((null != this.targetInfo && this.targetInfo.srcid == Data.myKing.objid) || (null != this.targetInfo && this.targetInfo.targetid == Data.myKing.objid))
				{
					//2012-05-22 andy 播放技能声音
					MusicMgr.playWave(MusicDef.getSkillMusic(this.skill, SKILL_EFFECT_X));
				}
			}
		}

		/**
		 * 技能飞行控制
		 */
		public function Three_Move():void
		{
			var p1:Point=new Point(this.targetInfo.src_mapx, this.targetInfo.src_mapy);
			var p2:Point=new Point(this.targetInfo.target_mapx, this.targetInfo.target_mapy);
			MapCl.gridToMap(p1);
			MapCl.gridToMap(p2);
//			SkillEffectManager.instance.adjustSkillStartFlyPosition(p1,p2);
			var distance:Number=Point.distance(p1, p2);
			var moveTime:Number=distance / (skill_model.speed);
			//优化
//			var moveTime_:Number = Number(moveTime.toFixed(2));
			var moveTime_:Number=0.3; //由策划配置技能移动时间
			if (distance > 500)
				moveTime_=0.4;
//			var moveTime:Number=distance / 350;
			var sw:int=width;
			var sh:int=height;
			var tx:int=0;
			var ty:int=0;
			if (skill_model.effect3 == 4013031)
			{
				if (distance <= 177)
				{
					if (this.numChildren > 0)
					{
						this.removeChildAt(0);
					}
					setTimeout(fightComplete, moveTime_);
					//攻击延迟死亡
					setTimeout(onSkillEffectMoveComplete, moveTime_);
					return;
				}
			}
			Three_Sub_EndMapXYOffset();
			var p:Point=SkillEffectManager.instance.AdjustEndMapXYBySKE3(this.targetInfo, sw, sh, this.d_as_Movie, this.skill, this.angle);
			TweenLite.to(this, moveTime_, {x: p2.x + tx, y: p2.y + ty, ease: Linear.easeIn, onComplete: onSkillEffectMoveComplete});
			setTimeout(fightComplete, moveTime_*1000);
		}

		/**
		 * 校正终点位置
		 */
		private function Three_Sub_EndMapXYOffset():void
		{
			return;
			var GameKing:IGameKing=targetKing;
			if (null == GameKing)
			{
				return;
			}
			//偏移量不能超过400，以免引起跨屏错误,而且人物还要换方向
			//由于人跑得较快，现改成500
			//加上全屏，屏幕宽高，现改成800
			var p1:Point=new Point(this.targetInfo.target_mapx, this.targetInfo.target_mapy);
			var p2:Point=new Point(GameKing.mapx, GameKing.mapy);
			if (Point.distance(p1, p2) < 800)
			{
				this.targetInfo.target_mapx=GameKing.mapx;
				this.targetInfo.target_mapy=GameKing.mapy;
			}
		}

		private function onSkillEffectMoveComplete():void
		{
			TweenLite.killTweensOf(this, true);
			SkillTrackReal.instance.mapObjStatus(this.target_info.targetid);
			clear();
		}

		private function fightComplete():void
		{
			Action.instance.fight.CFightInstant_Complete(this.target_info, this.skill);
		}

		/**
		 * 飘血
		 */
		public function Four_MoveComplete():void
		{
			onSkillEffectMoveComplete();
//			WaftNumManager.instance.showTrail(this.target_info.targetid,this.target_info.srcid);
			//Debug.instance.traceMsg("Four_MoveComplete");
			clear();
		}

		public function clear():void
		{
			//
			this.visible=false;
			//
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
					(d as ResMc).playOverAct=null;
					//(d as Movie).stop();
					(d as ResMc).close();
				}
			}
			//
			if (null != this.parent)
			{
				this.parent.removeChild(this);
			}
			//
			this.visible=true;
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
	}
}
