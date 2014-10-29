package scene.skill2
{
	import com.greensock.TweenLite;
	
	import com.bellaxu.res.ResMc;
	
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
	import com.bellaxu.def.DepthDef;
	import scene.manager.SceneManager;
	import com.bellaxu.def.MusicDef;
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
	 * 
	 * for test
	 * 
	 */ 
	public class SkillEffect35 extends WorldSprite implements ISkillEffect
	{		
		
		public function DelHitArea():void
		{
			//
		}
		
		public function UpdHitArea():void
		{
			//
		}
		
		public static const SKILL_EFFECT_X:int = 45;
		
		/**
		 * 内容的默认播放次数
		 */ 
		public static const D_AS_MOVIE_PLAY_COUNT:int = 0;//10;//1;
		
		private var _fx:String = "F1";//"F1";
		
		public function get DZ():String
		{			
			return KingActionEnum.GJ;
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
		
		
		
		public function SkillEffect35(objid_:uint)
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
			//this.dbID = dbID_;
			
			this.targetInfo = targetInfo_.clone();
			
			//test
			
			this.graphics.clear();
			this.graphics.beginFill(0xFF0000);
			this.graphics.drawRect(0,0,35,35);
			this.graphics.endFill();
			
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
			
		}		
		
		public function One_Sub_SysConfig(hasMe:Boolean=true,hasMePet:Boolean=true,hasMeMon:Boolean=true):void
		{
			
			
		}
		
		/**
		 * 增加到屏幕
		 */ 
		public function Two_AddChild():void
		{					
						
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
			
			moveTime = 3.0;
			
			//move
			useTweenLite = true;
		
			
			TweenLite.to(this, moveTime, 
					//TweenLite.to(this, 30, 
					{	
						onComplete:Four_MoveComplete
					}
					
				);
			
			
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