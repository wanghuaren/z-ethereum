package scene.skill2
{
	
	import com.bellaxu.def.DepthDef;
	import com.bellaxu.def.LibDef;
	import com.bellaxu.def.MusicDef;
	import com.bellaxu.mgr.MusicMgr;
	import com.bellaxu.model.lib.Lib;
	import com.bellaxu.res.ResMc;
	import com.greensock.TweenLite;
	
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_SkillResModel;
	import common.config.xmlres.server.Pub_Skill_SpecialResModel;
	
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
	
	import world.graph.WorldSprite;
	
	/**
	 * 与SkillEffect3的区别是3是飞到后消失，
	 * 4是直接飞到后原地播动画后消失
	 * 
	 *  与4的区别是4是协议不同，
	 * 4是走战斗协议，这里是走地面SCSpecialEffect协议
	 * 
	 * 资源读表也不同
	 * 
	 */ 
	public class SkillEffect32 extends WorldSprite implements ISkillEffect
	{
		public function DelHitArea():void
		{
			//
		}
		
		public function UpdHitArea():void
		{
			//
		}
		
		public static const SKILL_EFFECT_X:int = 42;
		
		/**
		 * 内容的默认播放次数
		 */ 
		public static const D_AS_MOVIE_PLAY_COUNT:int = 1;//10;//1;
		
		private var _fx:String = "F1";
		
		public function get DZ():String
		{
			//return KingActionEvent.PuTong_DaiJi;
			return KingActionEnum.GJ;
		}
		
		public function get skill_model():Pub_SkillResModel
		{
			return null;
			
		}
		
		public function get skill_special_model():Pub_Skill_SpecialResModel
		{
	//项目转换		return Lib.getObj(LibDef.PUB_SKILL_SPECIAL, this.dbID.toString());
	return XmlManager.localres.SkillSpecialXml.getResPath(this.dbID) as Pub_Skill_SpecialResModel;
		}
		
		public function getFx(k_roleFX:String):String
		{			
	//项目转换		var model_special:Pub_Skill_SpecialResModel = Lib.getObj(LibDef.PUB_SKILL_SPECIAL, this.dbID.toString());
			var model_special:Pub_Skill_SpecialResModel = XmlManager.localres.SkillSpecialXml.getResPath(this.dbID) as Pub_Skill_SpecialResModel;
			if(null == model_special)
				return "F1";
			if(1 == model_special['effect_fx'])
				k_roleFX = "F1";
			return k_roleFX;
		}
		
		public function get FX():String
		{
			return _fx;
		}
		
		public function set FX(value:String):void
		{
			_fx = getFx(value);
		}
		
		//public var skill:int;
		/**
		 * 技能资源ID
		 */
		private var m_nSkillModelId:int;
		
		public function get skillModelId():int
		{
			return m_nSkillModelId;
		}
		public var dbID:int;
		public var targetInfo:TargetInfo;
		
		public var d_as_Movie:Boolean;
		public var d_height:int;
		
		//
		public var moveTime:Number;
		
		
		
		public function SkillEffect32(objid_:uint)
		{
			this.objid = objid_;
		}		
		
		
		public function init():void
		{
			this.mouseEnabled = this.mouseChildren = false;
			d_as_Movie = false;
			d_height = 10;
			_fx = "F1";
			this.visible = true;
			this.depthPri = DepthDef.TOP;
		}
		
		public function setData(dbID_:int,targetInfo_:TargetInfo):void
		{
			this.m_nSkillModelId = this.dbID = dbID_;
			
			this.targetInfo = targetInfo_.clone();
			
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
			return this.targetInfo.srcid == Data.myKing.objid?true:false;
		}
				
		public function get isMePet():Boolean
		{
			var curPetId:int = Data.myKing.CurPetId;
			var myKingRoleId:int = Data.myKing.roleID;
			
			if(0 ==  this.targetInfo.srcid)
			{
				return false;
			}
			
			var byCurPetId:Boolean = this.targetInfo.srcid == curPetId?true:false;
			
			if(byCurPetId)
			{
				return byCurPetId;
			}
			
			//
			var byMasterId:Boolean = false;
			
			var srcK:IGameKing = srcKing;
			
			if(null != srcK)
			{
				byMasterId = srcK.masterId == myKingRoleId?true:false;
			}
			
			return byMasterId;
		}
		
		public function get isMeMon():Boolean
		{
			var myKingRoleId:int = Data.myKing.roleID;
			
			var byMasterId:Boolean = false;
			
			var srcK:IGameKing = srcKing;
			
			if(null != srcK)
			{
				byMasterId = srcK.masterId == myKingRoleId?true:false;
			}
			
			return byMasterId;
		}
		
		/**
		 * 创建效果文件
		 */ 
		public function One_CreateEffect():void
		{
			One_Sub_SysConfig();
			
	//项目转换		var model_special:Pub_Skill_SpecialResModel = Lib.getObj(LibDef.PUB_SKILL_SPECIAL, this.dbID.toString());
			var model_special:Pub_Skill_SpecialResModel = XmlManager.localres.SkillSpecialXml.getResPath(this.dbID) as Pub_Skill_SpecialResModel;
			var effectX_value:int = 0;//0;//400063
			if(null != model_special)
				effectX_value = model_special.effect;		
			
			var d:DisplayObject =  SkillEffectManager.instance.getPool(0,
																	   SKILL_EFFECT_X,
																	   effectX_value,
																	   this.targetInfo.src_sex,
																	   this.targetInfo.srcid);
																		
			if(null == d)
			{
				//飞行元件不可为null
				throw new Error("SkillEffect " + SKILL_EFFECT_X .toString() +": d can not be null");
			}
			
			//
			var pA:Point  = new Point(this.targetInfo.src_mapx,this.targetInfo.src_mapy);
			var pB:Point = new Point(this.targetInfo.target_mapx,this.targetInfo.target_mapy);
			MapCl.gridToMap(pA);
			MapCl.gridToMap(pB);
			var angle:int = MapCl.getAngle(pB,pA);
			
			//F1
			//地面上的不需要变方向
			//var fx:String = "F1";
			this.FX = MapCl.getWASD(angle);
				
			if(d as ResMc)
			{
				MapCl.setFangXiang((d as ResMc),this.DZ,this.FX,null);
			
			}else if(d as SkinBySkill)
			{
				(d as SkinBySkill).setAction(this.DZ,this.FX);
			}
				
			//if(null != mo)
			if(d as ResMc)
			{
				d_as_Movie = true;
					
				//d_height = mo.height;
					
				d_height = (d as ResMc).height;
					
					
							}
			
			this.addChild(d);
		}		
		
		public function One_Sub_SysConfig(hasMe:Boolean=true,hasMePet:Boolean=true,hasMeMon:Boolean=true):void
		{
			
			if(hasMe)
			{
				if(this.isMe)
				{
					return;
				}
			}
			
			if(hasMePet)
			{
				if(this.isMePet)
				{
					return;
				}
			}
			
			if(hasMeMon)
			{
				if(this.isMeMon)
				{
					return;
				}
			}
			
			this.visible = !Action.instance.sysConfig.alwaysHideHumanAndPet;
		}
		
		/**
		 * 增加到屏幕
		 */ 
		public function Two_AddChild():void
		{					
			var w:Number = this.width;
			var h:Number = this.height;
			
			//未加载完时的坐标修正
			if(0 == w &&
				0 == h)
			{
				
			}//end if
						
			//确定终点前校正一下终点坐标			
			//这里不需要
			//Two_Sub_EndMapXYOffset();
			
			//	
			this.x = MapCl.gridXToMap(this.targetInfo.target_mapx);
			this.y = MapCl.gridYToMap(this.targetInfo.target_mapy);
			
			//			
			SceneManager.instance.AddItem_Core(this);
			
			//
			Two_Sub_Sound();
		}
		
		/**
		 * 播放技能声音
		 */ 
		private function Two_Sub_Sound():void
		{			
			if (null != this.skill_special_model &&
				"" != skill_special_model.sound)
			{
				if(this.isMe || this.isMePet || this.isMeMon)
				{
					//2012-05-22 andy 播放技能声音
					MusicMgr.playWave(MusicDef.getSoundPath(skill_special_model.sound));
				}
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
			var useTweenLite:Boolean = true;
			
			//get time
	//项目转换		var model_special:Pub_Skill_SpecialResModel = Lib.getObj(LibDef.PUB_SKILL_SPECIAL, this.dbID.toString());
			var model_special:Pub_Skill_SpecialResModel = XmlManager.localres.SkillSpecialXml.getResPath(this.dbID) as Pub_Skill_SpecialResModel;

			//0需要播一次，
			//if(0 == model_special.effect_time && 
			//if(this.hasSkinBySkillAndRoleLoaded)
			//{
			//	useTweenLite = false;
			//}
			//else
			//{
				useTweenLite = true
					
				//moveTime = model_special.effect_time / 1000;
				moveTime = 1000 / 1000;
			//}
			
			//check
			if(!isFinite(moveTime) ||
				isNaN(moveTime) ||
				0 == moveTime)
			{
				moveTime = 1.0;
			}
			
			//move
			if(useTweenLite)
			{
				TweenLite.to(this, moveTime, 
				//TweenLite.to(this, 30, 
					{	
						onComplete:Four_MoveComplete
					}
					
				);
				
			}else
			{
				//----------------------------------------------------
				//设playCount
				//有一个设了就行
				var d:DisplayObject;	
				var i:int;
				
				for(i=0;i<this.numChildren;i++)
				{
					d = this.getChildAt(i);
					
					if(d as ResMc)
					{
						MapCl.setFangXiang(d as ResMc,this.DZ,this.FX,null,D_AS_MOVIE_PLAY_COUNT,Four_MoveComplete);
						//MapCl.setFangXiang(d as Movie,this.DZ,GameKing.roleFX,null);
						
						break;
						
					}else if(d as SkinBySkill)
					{
						MapCl.setFangXiang((d as SkinBySkill).getRole(),this.DZ,this.FX,null,D_AS_MOVIE_PLAY_COUNT,Four_MoveComplete);
						//MapCl.setFangXiang((d as SkinBySkill).getRole(),this.DZ,GameKing.roleFX,null);
						
						break;						
					}				
				}
				
				//-------------------------------------------------------
				
			}
			
			
		}
		
		/**
		 * 飘血
		 */ 
		public function Four_MoveComplete():void
		{			
			TweenLite.killTweensOf(this,true);
			//
			clear();
		}
		
		/**
		 * 校正终点位置
		 * 这里与SkillEffect3不同，是Two
		 */ 
		private function Two_Sub_EndMapXYOffset():void
		{
			var GameKing:IGameKing = targetKing;
			
			if(null == GameKing)
			{
				return;
			}
			
			this.targetInfo.target_mapx = GameKing.mapx;
			this.targetInfo.target_mapy = GameKing.mapy;
			
		}
		
		public function clear():void
		{
			var len:int = this.numChildren;
			
			var d:DisplayObject;
			for(var i:int=0;i<len;i++)
			{
				d = this.removeChildAt(0);
				
				if(d as SkinBySkill)
				{
					(d as SkinBySkill).removeAll();
					
				}else if(d as ResMc)
				{
					//(d as Movie).stop();
					(d as ResMc).close();
				}				
			}
			//====whr==========
			d=null;
			//
			if(null != this.parent)
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
			
			for(i=0;i<this.numChildren;i++)
			{
				d = this.getChildAt(i);
				
				if(d as SkinBySkill)
				{
					if(null != (d as SkinBySkill).getRole())
					{
						return true;
					}
				}
				
				if(d as ResMc)
				{
					return true;
				}
				
			}//end for
			
			return false;
		}
				
		public function get srcKing():IGameKing
		{
			var GameKing:IGameKing = SceneManager.instance.GetKing_Core(targetInfo.srcid);
			
			return GameKing;
		}
		
		public function get targetKing():IGameKing
		{
			var GameKing:IGameKing = SceneManager.instance.GetKing_Core(targetInfo.targetid);
			
			return GameKing;
		}
		
		
	}
}