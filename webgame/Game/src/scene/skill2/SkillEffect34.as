package scene.skill2
{
	import com.bellaxu.def.DepthDef;
	import com.bellaxu.res.ResMc;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import common.managers.Lang;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import scene.action.Action;
	import scene.event.KingActionEnum;
	import scene.king.IGameKing;
	import scene.king.TargetInfo;
	import scene.manager.SceneManager;
	
	import world.graph.WorldSprite;

	/**
	 * ghost effect
	 */ 
	public class SkillEffect34 extends WorldSprite implements ISkillEffect
	{		
		
		public function DelHitArea():void
		{
			//
		}
		
		public function UpdHitArea():void
		{
			//
		}
		
		private var _fx:String = "F1";//"F1";
		
		public function get DZ():String
		{			
			return KingActionEnum.DJ;
		}
		
		public function get FX():String
		{
			return _fx;
		}
		
		public var targetInfo:TargetInfo;
	
		public var moveTime:Number;
		
		public var targetPoint:Point;
		
		
		public var bezierX:int;
		
		public var bezierY:int;
		/**
		 * 技能资源ID
		 */
		private var m_nSkillModelId:int;
		
		public function get skillModelId():int
		{
			return m_nSkillModelId;
		}
		public var jn:int;
		
		public var jumpFrame:int;
		
		
		//
		public function SkillEffect34(objid_:uint)
		{
			this.objid = objid_;
		}		
		
		
		public function init():void
		{
			this.mouseEnabled = this.mouseChildren = false;			
			this.visible = true;
			this.depthPri = DepthDef.BOTTOM;
			
			jn = -1;
			
			jumpFrame = -1;
		}
		
		public function setData(
			jumpTime:Number,
			tP:Point,
			bezierX_:int,
			bezierY_:int,
			targetInfo_:TargetInfo,
			j_:int):void
		{
			//
			moveTime = jumpTime;
						
			targetPoint = tP.clone();
			
			bezierX = bezierX_;
			
			bezierY = bezierY_;
						
			this.targetInfo = targetInfo_.clone();
			
			if(-1 == jn)
			{
				jn = j_;
			}
			
			if(-1 == jumpFrame)
			{
				jumpFrame = 1;
			}
			//test
			
			/*this.graphics.clear();
			this.graphics.beginFill(0x00ff00);
			this.graphics.drawRect(0,0,100,100);
			this.graphics.endFill();*/
			
		}
		
		public function get target_info():TargetInfo
		{
			return this.targetInfo;
		}
		
		
		
		/**
		 * 创建效果文件
		 */ 
		public function One_CreateEffect():void
		{
			One_Sub_SysConfig();
			
			//One_CreateEffect_Role_Bitmap();
			//this.addChild(d);
		}		
		
		public function One_CreateEffect_Role_Bitmap(jumpFrame_:int):void
		{
			var d:Bitmap = this.getChildByName("b_d") as Bitmap;
			var srcK:IGameKing = this.srcKing;
			
			if(1 == this.jumpFrame && 2 == jumpFrame_)
			{
				if(null != d)
				{
					if(null != d.parent)
					{
						d.parent.removeChild(d);
					}
				}
				jumpFrame  = 2;
			}
						
			if(null == d)
			{				
				if(null != srcK)
				{
					if(null != srcK.getSkin().getRole())
					{
//						if(null != srcK.getSkin().getRole().currentBitmapInfo)
//						{
//							if(null != srcK.getSkin().getRole().currentBitmapInfo.bitmapData)
							if(null !=  srcK.getSkin().getRole().currentBitmapData)	
							{
								//var bi:IBitmapInfo = srcK.getSkin().getRole().currentBitmapInfo;
								//var bd:BitmapData = bi.bitmapData;
								var bd:BitmapData = srcK.getSkin().getRole().currentBitmapData;
								var b:Bitmap = new Bitmap(bd);
								b.name = "b_d";
								
								b.y = 0 - bd.height;
																
								this.addChild(b);

								d = b;
							}						
//						}				
						
						
					}
				}
			}
			
			//
			if(null != d)
			{
				try
				{
					d.y = 0 - (d as Bitmap).bitmapData.height;
				}
				catch(exd:Error)
				{}
				
				if(null != srcK)
				{
					if(srcK.roleFX == "F6" ||
					   srcK.roleFX == "F7" ||
					   srcK.roleFX == "F8")
					{
						//d.x = 0;
						d.scaleX = -1;
						
						//try
						//{
							//d.x = d.x + d.bitmapData.width / 2;
						//}
						//catch(exd:Error)
						//{}
						
					}else if(srcK.roleFX == "F1")
					{
						
						d.scaleX = 1;
						
						try
						{
							d.x = 0 - d.bitmapData.width / 2;
						}
						catch(exd:Error)
						{}
						
					}else if(srcK.roleFX == "F3" || srcK.roleFX == "F2" || srcK.roleFX == "F4")
					{
						
						d.scaleX = 1;
						
						try
						{
							d.x = 0;
						}
						catch(exd:Error)
						{}
						
					}
					else
					{
						
						d.scaleX = 1;
						
						try
						{
							d.x = 0 - d.bitmapData.width / 2;
						}
						catch(exd:Error)
						{}
						
					}
				
				}
				
			}
		}
		
		
		/**
		 * 增加到屏幕
		 */ 
		public function Two_AddChild():void
		{	
			//	
			this.x = this.targetInfo.src_mapx;
			this.y = this.targetInfo.src_mapy;
			
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
			
			//
			var arrJump:Array = Lang.getLabelArr("arr_jump");	
			var blurX_:int = 2;
			var blurY_:int = 2;
			var amount_:Number = 0.4;
			var jnMax_:int = 7;
			var alphaMax_:Number = 0.9; 
			
			if(null != arrJump && arrJump.length > 0){
				jnMax_  = parseInt(arrJump[0]) + 1;
				alphaMax_ = arrJump[1];
				blurX_ = arrJump[2];
				blurY_ = arrJump[3];
				amount_ = arrJump[4];
			}
			
			
			//
			TweenMax.to(this, 0, {blurFilter:{blurX:blurX_, blurY:blurY_}});
			
			//
			TweenMax.to(this, 0, {colorMatrixFilter:{colorize:0x000000, amount:amount_}});//0.5
			
			//this.alpha = 0.1;
			//this.alpha = 1.0;
			//TweenMax.to(this, moveTime, {alpha:0.9});
			
			this.alpha = (jnMax_ - jn) * 0.1;			
			
			//
			TweenMax.to(this, moveTime, {				
				
				x:targetPoint.x, 
				y:targetPoint.y, 
				bezierThrough:[{x:bezierX, y:bezierY}],
				ease:Linear.easeIn,//由快(起)->慢(顶)->快(落)
				onUpdate:EnterToJump,
				onComplete:Four_MoveComplete
			});
			
			
		}
		
		public function EnterToJump():void
		{
			var pt1:Point = new Point(this.x,this.y);
			
			var arrJump:Array = Lang.getLabelArr("arr_jump");				
			var d_:int = 150;				
			if(null != arrJump && arrJump.length > 0){
				d_ = arrJump[5];
			}
			
			var jumpFrame_:int = 1;
			if(Point.distance(pt1,this.targetPoint) < d_)
			{
				jumpFrame_=2;				
			}
			
			One_CreateEffect_Role_Bitmap(jumpFrame_);
			
			
		}
		
		/**		
		 */ 
		public function Four_MoveComplete():void
		{			
			//
			clear();
		}
		
		
		public function clear():void
		{
			var dis:DisplayObject;
			while(this.numChildren > 0)
			{
				dis = this.removeChildAt(0);
				if (dis is ResMc)
				{
					ResMc(dis).close();
				}
				else if (dis is Bitmap)
				{
					Bitmap(dis).bitmapData = null;
				}
					
			}
			
			if(null != this.parent)
			{
				this.parent.removeChild(this);
			}
			
		}
		
		
		
		//get
		public function get srcKing():IGameKing
		{
			var GameKing:IGameKing = SceneManager.instance.GetKing_Core(targetInfo.srcid);
			
			return GameKing;
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
			
//			if(hasMePet)
//			{
//				if(this.isMePet)
//				{
//					return;
//				}
//			}
//			
//			if(hasMeMon)
//			{
//				if(this.isMeMon)
//				{
//					return;
//				}
//			}
			
			this.visible = !Action.instance.sysConfig.alwaysHideHumanAndPet;
		}
		
		public function get isMe():Boolean
		{
			return true;
		}
		
		
		public function get isMePet():Boolean
		{			
			return true;
		}
		
		public function get isMeMon():Boolean
		{			
			return true;
		}
		
		
		
		
		
		
		
		
		
	}
}