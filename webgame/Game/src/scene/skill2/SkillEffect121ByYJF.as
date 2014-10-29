package scene.skill2
{
	import com.greensock.TweenLite;
	
	import common.utils.clock.GameClock;
	
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
	import scene.utils.MapCl;
	import scene.utils.MapData;
	
	import world.FileManager;
	import world.IWorld;
	import world.WorldEvent;
	import world.graph.WorldSprite;
	import world.model.file.BeingFilePath;
	import world.model.file.SkillFilePath;
	import world.type.BeingType;
	import world.type.ItemType;
	import world.type.WorldType;
	
	/**
	 * 御剑飞行专用
	 */ 
	public class SkillEffect121ByYJF extends WorldSprite implements ISkillEffect
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
		
		public static const SKILL_EFFECT_X:int = 111;
		
		//
		//public var targetId:uint;
		
		public var targetK:IGameKing;
		/**
		 * 技能资源ID
		 */
		private var m_nSkillModelId:int;
		
		public function get skillModelId():int
		{
			return m_nSkillModelId;
		}
		public var path:String;
		
		public function SkillEffect121ByYJF()
		{
			
		}
		
		public function get skill_model():Object
		{
			return null;
			
		}
		
		/**
		 * 方向 . 美术那边提供的效果不全，因此这里需要根据某些特效写死。
		 * @return 
		 * 
		 */		
		public function get FX():String
		{
			var fx_:String= "F1";
			
			switch(path)
			{				
				case "yjf_sword":
					
					fx_ = "F1";
					
					//
					if(null != this.targetK)
					{
						fx_ = this.targetK.roleFX;
					}
					
					break;		
				
				default:
					break;
					//throw new Error("can not switch source:" + path);
			}
			
			
			
			
			return fx_;		
		}
		
		/**
		 * 动作 
		 * @return 
		 * 
		 */		
		public function get DZ():String
		{			
			var dz_:String = KingActionEnum.DJ;
			
			switch(path)
			{				
				
				case "yjf_sword":
					
					//dz_ = KingActionEnum.PB;		
					dz_ = KingActionEnum.DJ;		
					break;				
			
				default:
					break;
					//throw new Error("can not switch source:" + path);
			}
			
			return dz_;		
		}
		
		/**
		 * 播放动画次数  0 表示无限次数播放， 1 表示只播放一次  2 表示两次，以此类推。
		 * @return 
		 * 
		 */		
		public function get PC():int
		{
			var pc_:int = 0;
			
			switch(path)
			{				
				case "yjf_sword":
					pc_ = 0;
					break;				
				
				default:
					break;
					//throw new Error("can not switch source:" + path);
			}
			
			return pc_;		
			
		}
		
		/**
		 * 动作做了一半要执行什么函数 
		 * @return 
		 * 
		 */		
		public function get POA():Function
		{
			var poa_:Function;
			
			switch(path)
			{				
				case "yjf_sword":
					poa_ = null;
					break;				
				
				default:
					throw new Error("can not switch source:" + path);
			}
			
			return poa_;		
			
			
		}
		
		/**
		 * 动画移动时间，主要是 TweenLite 中参数使用
		 * @return 
		 * 
		 */		
		public function get moveTime():int
		{
			var t:Number = 1.0; 
			
//			switch(path)
//			{				
//				default:
//					throw new Error("can not switch source:" + path);
//			}
			
			return t;
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
		/**
		 * 设置目标对象的 objid 和  特效类型的字符串 例如： 修炼特效 --> "xiuLian"
		 * @param targetId_    对象的 objid
		 * @param path_        特效类型的字符串
		 * 
		 */		
		//public function setData(targetId_:uint,path_:String):void
		public function setData(targetK_:IGameKing,path_:String):void
		{
			this.targetK = targetK_;
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
			return true;
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
			var GameKing:IGameKing = this.targetK;
			
			if(null == GameKing)
			{
				GameKing = Data.myKing.king;
				
				//
				if(null == GameKing)
				{
					return;		
				}		
			}
			
			//
			Two_Sub_RefreshFx(GameKing);
			
			this.y = 0;
			this.x = 0;
			
			//指定添加到人物身上的位置
			switch(this.path)
			{				
				
				case "yjf_sword":
					
					GameKing.getSkin().foot.addChild(this);
					
					Two_Sub_RefreshPos(GameKing);
					
					break;				
			
				default:
					GameKing.getSkin().effectUp.addChild(this);
					break;
			}
			
		}
		
		public function Two_Sub_RefreshFx(k:IGameKing):void
		{				
			//loop use
			var i:int;
			
			//调整方向
			var d:DisplayObject;	
			
			for(i=0;i<this.numChildren;i++)
			{
				d = this.getChildAt(i);
				
				if(d as ResMc)
				{
					//MapCl.setFangXiang(d as Movie,this.DZ,k.roleFX);
					MapCl.setFangXiang(d as ResMc,this.DZ,this.FX,k,this.PC);
					
				}else if(d as SkinBySkill)
				{
					//
					//(d as SkinBySkill).setAction(this.DZ,k.roleFX,0,null);
					(d as SkinBySkill).setAction(this.DZ,this.FX,0,null);
					
				}
				
			}//end for	
		}
		
		private function Two_Sub_RefreshPos(k:IGameKing):void
		{
			
			if(null == k)
			{
				return;
			}
			
			var roleFx:String = k.roleFX;
			
			switch(roleFx)
			{
				case "F1":
					
					
					//-------------------------yjf_sword-----------------------------------------
					
					if("yjf_sword" == this.path)
					{
						this.x =  0;
												
						//注意是加在foot上,该物件当前方向的高度/2
						//this.y = 70;
						
						this.y = 100;
						
						if(null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}		
						
					}
					
					break;
				
				
				
				
				case "F2":			
					//-------------------------yjf_sword-----------------------------------------
					
					if("yjf_sword" == this.path)
					{
						//this.x =  0;
						this.x = -50;
																		
						//注意是加在foot上,该物件当前方向的高度/2
						//this.y = 60;
						
						this.y = 80;
						
						if(null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}		
						
					}
					
					break;
				
				case "F3":
					//-------------------------yjf_sword-----------------------------------------
					
					if("yjf_sword" == this.path)
					{
						//this.x =  0;
						
						this.x = -60;
						
																		
						//注意是加在foot上,该物件当前方向的高度/2
						//this.y = 96/2;
						
						this.y = 60;
						
						if(null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}		
						
					}
					break;
				
				case "F4":
					
					//-------------------------yjf_sword-----------------------------------------
					
					if("yjf_sword" == this.path)
					{
						//this.x =  0;
						
						this.x =  -30;
												
						//注意是加在foot上,该物件当前方向的高度/2
						this.y =  60;						
						
						if(null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}		
						
					}
					
					
					break;
				
				case "F5":
					
					//-------------------------yjf_sword-----------------------------------------
					
					if("yjf_sword" == this.path)
					{
						this.x =  0;
						
						//注意是加在foot上,该物件当前方向的高度/2
						//this.y = 122/2;
						
						this.y = 80;
						
						if(null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}		
						
					}
					break;					
					
				case "F6":	
					//-------------------------yjf_sword-----------------------------------------
					
					if("yjf_sword" == this.path)
					{
						//this.x =  0;
						
						this.x =  30;
																		
						//注意是加在foot上,该物件当前方向的高度/2
						this.y = 99/2;
						
						if(null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}		
						
					}
					break;
				
				case "F7":		
					
					//-------------------------yjf_sword-----------------------------------------
					
					if("yjf_sword" == this.path)
					{
						this.x =  60;
												
						//注意是加在foot上,该物件当前方向的高度/2
						//this.y = 90/2;
						
						this.y = 60;
						
						if(null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}		
						
					}
					
					break;
				
				case "F8":	
					
					//-------------------------yjf_sword-----------------------------------------
					
					if("yjf_sword" == this.path)
					{
						//this.x =  0;
						this.x = 40;	
						
						//注意是加在foot上,该物件当前方向的高度/2
						this.y = 60;
						
						if(null == this.parent)
						{
							k.getSkin().foot.addChild(this);
						}		
						
					}
					break;
				
			}
			
			
			
		}
		
		
		
		/**
		 * 可看成是play
		 */ 
		public function Three_Move():void
		{
			//
			if("yjf_sword" == path)
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK__,Three_Sub_FrameHandler);
				GameClock.instance.addEventListener(WorldEvent.CLOCK__,Three_Sub_FrameHandler);
				
				return;
			}
			
			//一直显示，除非调用Four_MoveComplete
			if("yjf_sword" == path)
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
		
		public function Three_Sub_FrameHandler(e:Event):void
		{
			var k:IGameKing = this.targetK;
			
			if(null == k)
			{
				return;				
			}
			
			//refresh pos
			this.Two_Sub_RefreshPos(k);
			
			//refresh fx
			this.Two_Sub_RefreshFx(k);
			
			
		}
		
		
		/**
		 * 飘血
		 */ 
		public function Four_MoveComplete():void
		{
			//
			GameClock.instance.removeEventListener(WorldEvent.CLOCK__,this.Three_Sub_FrameHandler);
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
			var bfp:SkillFilePath;
			
			switch(path)
			{
				case "yjf_sword":
					
					bfp = FileManager.instance.getSkill12FileByFileName("yjf_sword");
					
					d =  SkillEffectManager.instance.getPoolBy12(bfp);
					
					break;
				
				default:
					throw new Error("can not switch source:" + path);
			}			
			
			return d;
		}
		
		public function get hasSkinBySkillAndRoleLoaded():Boolean
		{
			//loop use
			var i:int;
			
			//调整方向
			var d:DisplayObject;	
			
			for(i=0;i<this.numChildren;i++)
			{
				d = this.getChildAt(i);
				
				if(d as ResMc)
				{
					return true;
					
				}else if(d as SkinBySkill)
				{
					if(null != (d as SkinBySkill).getRole())
					{
						return true;
					}
				}
				
			}//end for
			
			return false;
		}
		
		
		
		
		
		
	}
}