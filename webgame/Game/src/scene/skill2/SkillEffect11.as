package scene.skill2
{
	import com.bellaxu.def.DepthDef;
	import com.bellaxu.res.ResMc;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import scene.action.Action;
	import scene.action.BodyAction;
	import scene.king.IGameKing;
	import scene.king.SkinBySkill;
	import scene.king.TargetInfo;
	import scene.manager.SceneManager;
	
	import world.graph.WorldSprite;
	
	/**
	 * 附加, 增补
	 * 
	 * 和SkillEffectX的区别是数据不走xml,缓存不走SkillEffectManager.instance.getPool
	 * 
	 * 走的是服务端playerData数据变化通知,缓存走SkillEffectManager.instance.getPoolByTrack
	 */ 
	public class SkillEffect11 extends WorldSprite implements ISkillEffect
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
		
		public static const SKILL_EFFECT_X:int = 11;
		
		//
		//public var targetInfo:TargetInfo;
		public var targetId:uint;
		/**
		 * 技能资源ID
		 */
		private var m_nSkillModelId:int;
		
		public function get skillModelId():int
		{
			return m_nSkillModelId;
		}
		public var path:String;
					
		public function SkillEffect11()
		{
		}
		
		public function get skill_model():Object
		{
			return null;
			
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
		 * 增加到人物身上
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
			GameKing.getSkin().effectUp.addChild(this);
			
		}
		
		public function Two_Sub_RefreshFx(k:IGameKing):void
		{	
			switch(path)
			{
				case "hpAdd":			
					
					this.x = 0;
					this.y = Action.instance.fight.GetRoleHeight(k) * -1;
					break;
				
				case "mpAdd":
					
					this.x = 0;
					this.y = Action.instance.fight.GetRoleHeight(k) * -1;
					break;
				
				case "fuhuo":
					
					this.x = 0;
					this.y = contentHeight * -1;//脚底
					
					break;		
				
				case "lvlUp":
					
					this.x = 0;
					this.y = contentHeight * -1;//脚底
					
					break;	
				
				case "xiuLian":
					
					this.x = 0;
					this.y = contentHeight * -1;//脚底
					
					break;	
				
				case "caiJi":
					
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
				case "hpAdd":			
					
					d =  SkillEffectManager.instance.getEmbedOtherPool("effect_hp_up");
					break;
				
				case "mpAdd":
					
					d =  SkillEffectManager.instance.getEmbedOtherPool("effect_mp_up");
					break;
				
				case "fuhuo":
					
					d =  SkillEffectManager.instance.getEmbedOtherPool("effect_fu_huo");
										
					break;		
				
				case "lvlUp":
					
					d =  SkillEffectManager.instance.getEmbedOtherPool("effect_lvl_up");
					
					break;
				
				case "xiuLian":
					
					//已作废，走pubres目录下的movie
					d =  SkillEffectManager.instance.getEmbedOtherPool("effect_xiu_lian");
					
					break;
				
				case "caiJi":
					
					d =  SkillEffectManager.instance.getEmbedOtherPool("effect_cai_ji");
					
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
				case "hpAdd":
					w = 44;
					break;
				
				case "mpAdd":
					w = 44;
					break;
				
				case "fuhuo":
					w = 140;
					
					break;			
				
				case "xiuLian":
					w = 185;
					
					break;	
				
				case "caiJi":
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
				case "hpAdd":
					h = 76;
					break;
				
				case "mpAdd":
					h = 67;
					break;
				
				case "fuhuo":
					h = 303;
					break;			
				
				case "lvlUp":
					h = 303;//342;
					break;	
				
				case "xiuLian":
					h = 161;
					break;	
				
				case "caiJi":
					h = 85;
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
				case "hpAdd":
					t = SkillEffectManager.HPADD_MOVE_TIME;
					break;
				
				case "mpAdd":
					t = SkillEffectManager.MPADD_MOVE_TIME;
					break;
				
				case "fuhuo":
					t = SkillEffectManager.FUHUO_MOVE_TIME;
					break;			
				
				case "lvlUp":
					t = SkillEffectManager.LVLUP_MOVE_TIME;
					break;	
				
				case "caiJi":
					t = SkillEffectManager.CAIJI_MOVE_TIME;
					break;	
				
				default:
					throw new Error("can not switch source:" + path);
			}
			
			return t;
		}
		
		
	}
}