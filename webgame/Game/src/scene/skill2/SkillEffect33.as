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
	import common.config.xmlres.server.Pub_Effect_SoundResModel;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
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
	import scene.utils.MapData;
	
	import world.FileManager;
	import world.IWorld;
	import world.graph.WorldSprite;
	import world.model.file.BeingFilePath;
	import world.type.BeingType;
	import world.type.ItemType;
	import world.type.WorldType;
	
	/**
	 * CCastSkillEffect协议专用
	 * 
	 * 其中美术元件的动作和方向为 待机 ，方向1 (此由策划王东保证)
	 */ 
	public class SkillEffect33 extends WorldSprite implements ISkillEffect
	{		
		
		public function DelHitArea():void
		{
			//
		}
		
		public function UpdHitArea():void
		{
			//
		}
		
		public static const SKILL_EFFECT_X:int = 43;
		
		/**
		 * 内容的默认播放次数
		 */ 
		public static const D_AS_MOVIE_PLAY_COUNT:int = 0;//10;//1;
		
		private var _fx:String = "F1";//"F1";
		
		public function get DZ():String
		{			
			return KingActionEnum.GJ;
		}
		
		public function get sound_model():Pub_Effect_SoundResModel
		{
 //项目转换			return Lib.getObj(LibDef.PUB_EFFECT_SOUND, this.dbID.toString());
			return XmlManager.localres.EffectSoundXml.getResPath(this.dbID) as Pub_Effect_SoundResModel;	
		}
		
		
		public function getFx(k_roleFX:String):String
		{
			return _fx;
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
		
		
		
		public function SkillEffect33(objid_:uint)
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
		
		public function setData(dbID_:int,targetInfo_:TargetInfo,depthPri_:int=DepthDef.TOP):void
		{
			this.m_nSkillModelId = this.dbID = dbID_;
			
			this.targetInfo = targetInfo_.clone();
			
			this.depthPri = depthPri_;
			//test
			
			/*
			this.graphics.clear();
			this.graphics.beginFill(0x001100);
			this.graphics.drawRect(0,0,150,150);
			this.graphics.endFill();
			*/
		}
		
		public function get target_info():TargetInfo
		{
			return this.targetInfo;
		}
		
		public function get isMe():Boolean
		{
			return false;
		}
		
		public function get isMePet():Boolean
		{			
			return false;
		}
		
		public function get isMeMon():Boolean
		{			
			return false;
		}
		
		/**
		 * 创建效果文件
		 */ 
		public function One_CreateEffect():void
		{
			//有些号会看不见
			//One_Sub_SysConfig();
			
			//
			var effectX_value:int = this.dbID;		
						
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
			this.x = this.targetInfo.target_mapx;
			this.y = this.targetInfo.target_mapy;// + this.height;
			
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
			//无声音
			if (null != this.sound_model &&
				"" != sound_model.sound)
			{
				//if(this.isMe || this.isMePet || this.isMeMon)
				//{
					//2012-05-22 andy 播放技能声音
					MusicMgr.playWave(MusicDef.getEffectSound(sound_model.sound));
				//}
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
			
			//0需要播一次，
			if(this.hasSkinBySkillAndRoleLoaded)
			{
				useTweenLite = false;
			}
			else
			{
				useTweenLite = true
				
				moveTime = 1.0;
				
			}
			
			//check
			if(!isFinite(moveTime) ||
				isNaN(moveTime) ||
				0 == moveTime)
			{
				moveTime = 1.0;
			}
			
			//move
			useTweenLite = true;
			
			if(400048 == this.dbID ||
			   400053 == this.dbID ||
			   400033 == this.dbID ||
			   400050 == this.dbID ||
			   400024 == this.dbID)
			{
				moveTime = 4.0;
			
			}			
			
			if(1 == this.dbID)
			{
				moveTime = 1.5;
			}
			
			if(2 == this.dbID ||			   
			   3 == this.dbID)
			{
				moveTime = 1.25;
			}
			
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
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
}