package scene.skill2
{
	import com.bellaxu.def.DepthDef;
	import com.bellaxu.def.LayerDef;
	import com.bellaxu.res.ResMc;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import scene.action.Action;
	import scene.action.BodyAction;
	import scene.king.IGameKing;
	import scene.king.SkinBySkill;
	import scene.king.SkinParam;
	import scene.king.TargetInfo;
	import scene.manager.SceneManager;
	
	import ui.base.mainStage.UI_index;
	
	import world.graph.WorldSprite;
	
	/**
	 * 附加, 增补
	 * 
	 * 和SkillEffectX的区别是数据不走xml,缓存不走SkillEffectManager.instance.getPool
	 * 
	 * 走的是服务端playerData数据变化通知,缓存走SkillEffectManager.instance.getPoolByTrack
	 * 
	 * 本类出现在Layer5上面，因为要求特效出现在所有窗体上，不要补挡住
	 */ 
	public class SkillEffect110 extends WorldSprite implements ISkillEffect
	{
		public function DelHitArea():void
		{
			//
		}
		
		public function UpdHitArea():void
		{
			//
		}
		
		private var _lastI:int;
		
		public function set lastI(value:int):void
		{
			_lastI = value;
		}
		
		public function get lastI():int
		{
			return _lastI;
		}
		
		public static const SKILL_EFFECT_X:int = 110;
		
		//
		//public var targetInfo:TargetInfo;
		public var targetId:uint;
		
		public var path:String;
		
		public function SkillEffect110()
		{
		}
		
		/**
		 * 本类不需要objid
		 */
		public function get name2():String
		{
			return "";
		}
		
		/**
		 * @private
		 */
		public function set name2(value:String):void
		{
			//_name2 = value;
		}
		
		public function get mapy():int
		{
			return 0;
		}
		
		public function get mapx():int
		{
			return 0;
		}
		
		public function set mapy(value:int):void
		{
			//_mapy = value;
		}
		
		public function set mapx(value:int):void
		{
			//_mapx = value;
		}
		
		public function init():void
		{
			this.mouseEnabled = this.mouseChildren = false;
			this.visible = true;
			this.depthPri = DepthDef.NORMAL;
		}
		
		//public function setData(targetInfo_:TargetInfo):void
		public function setData(targetId_:uint,path_:String):void
		{
			this.targetId = targetId_;
			//this.targetInfo = targetInfo_.clone();
			this.path = path_;
		}
		
		public function get target_info():TargetInfo
		{
			return null;
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
			//自身			
			var d:DisplayObject = getDisplayContent();
			
			//自身效果,如没有,d可为null
			
			if(null == d)
			{
				return;
			}
			
			this.addChild(d);
		}
		
		
		/**
		 * 增加到Layer5身上
		 */ 
		public function Two_AddChild():void
		{
			var GameKing:IGameKing = SceneManager.instance.GetKing_Core(this.targetId);
			
			if(null == GameKing)
			{
				return;				
			}
			
			//
			Two_Sub_RefreshFx(GameKing);
			
			//
			var targetK:IGameKing = GameKing;
									
			var targetGP:Point = new Point(targetK.x,targetK.y);
			targetGP = targetK.globalToLocal(targetGP);			
			var targetLP:Point = new Point(targetK.x - targetGP.x ,targetK.y - targetGP.y);	
			
			this.x = targetLP.x;
			this.y = targetLP.y - this.contentHeight + SkinParam.HUMAN_SKIN_DOWN;
			
			//
			//GameKing.getSkin().effectUp.addChild(this);
			
			LayerDef.tipLayer.addChild(this);
		}
		
		public function Two_Sub_RefreshFx(k:IGameKing):void
		{	
			switch(path)
			{				
				case "lvlUp":
					
					this.x = 0;
					this.y = contentHeight * -1;//脚底
					
					break;	
				
				default:
					throw new Error("can not switch source:" + path);
			}
		}
		
		/**
		 * 可看成是play
		 */ 
		public function Three_Move():void
		{
			//一直显示，除非调用Four_MoveComplete
			if("xiuLian" == path ||
				"caiJi" == path)
			{
				return;
			}
			
			//
			TweenLite.to(this, moveTime, 
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
			
			//
			if(null != this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		
		public function getDisplayContent():DisplayObject
		{
			var d:DisplayObject; 
			
			switch(path)
			{
				
				case "lvlUp":
					
					d =  SkillEffectManager.instance.getEmbedOtherPool("effect_lvl_up");
					
					break;				
				
				
				default:
					throw new Error("can not switch source:" + path);
			}			
			
			if(d as MovieClip)
			{
				(d as MovieClip).gotoAndPlay(1);
			}
			
			return d;
		}
		
		public function get contentWidth():int
		{			
			var w:int; 
			
			switch(path)
			{
								
				case "lvlUp":
					w = 64;
					
					break;	
				
				default:
					throw new Error("can not switch source:" + path);
			}
			
			return w;
			
		}
		
		public function get contentHeight():int
		{
			var h:int; 
			
			switch(path)
			{						
				
				case "lvlUp":
					h = 303;//342;
					break;	
				
				default:
					throw new Error("can not switch source:" + path);
			}
			
			return h;
		}
		
		
		public function get moveTime():int
		{
			var t:Number; 
			
			switch(path)
			{
				
				case "lvlUp":
					t = SkillEffectManager.LVLUP_MOVE_TIME;
					break;	
								
				default:
					throw new Error("can not switch source:" + path);
			}
			
			return t;
		}
		
		
	}
}