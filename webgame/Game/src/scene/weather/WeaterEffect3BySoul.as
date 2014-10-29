package scene.weather
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import com.bellaxu.res.ResMc;
	import engine.event.DispatchEvent;
	
	import netc.Data;
	import netc.dataset.MyCharacterSet;
	
	import scene.event.KingActionEnum;
	import scene.king.IGameKing;
	import scene.king.SkinBySkill;
	import scene.king.TargetInfo;
	import com.bellaxu.def.DepthDef;
	import scene.manager.SceneManager;
	import scene.utils.MapCl;
	
	import ui.base.mainStage.UI_index;
	
	import world.FileManager;
	import world.graph.WorldSprite;
	import world.model.file.SkillFilePath;
	
	/**
	 * 与SkillEffect3的区别是3是飞直线，飞到后消失，
	 * 
	 * 本类专用于魂点的飞行，飞的是曲线，怪物死亡后触发
	 * 
	 */ 
	public class WeaterEffect3BySoul extends WorldSprite implements IWeaterEffect
	{
		public function DelHitArea():void
		{
			//
		}
		
		public function UpdHitArea():void
		{
			//
		}
		
		public function get DZ():String
		{
			return KingActionEnum.GJ;
		}
		
		public function get FX():String
		{
			return "F1";
		}
		
		public var targetInfo:TargetInfo;
		
		public var d_as_Movie:Boolean;
		
				
		/**
		 * 先飞远
		 * 
		 * 4格
		 * 35 * 4  = 140
		 * 
		 * 由于加上了随机，现在5格
		 */ 
		//public const far:int = 140;
		public static const far:int = 175;
		
		public function get ranFar():int
		{
			var ranResult:int = Math.floor(far * Math.random());
			
			//最少2格,70
			//现调为50
			if(ranResult < 50)
			{
				ranResult = 50;
			}
			
			return ranResult;
		}
				
		public function WeaterEffect3BySoul(objid_:uint)
		{
			this.objid = objid_;
		}
		
		public function init():void
		{
			this.mouseEnabled = this.mouseChildren = false;
			d_as_Movie = false;
			this.depthPri = DepthDef.TOP;
		}
		
		public function setData(targetInfo_:TargetInfo):void
		{			
			this.targetInfo = targetInfo_.clone();
		}
		
		
		/**
		 * 创建效果文件
		 */ 
		public function One_CreateEffect():void
		{
			/*var p:Shape = new Shape();			 
			
			p.graphics.beginFill(0x000000);
			p.graphics.drawRect(0,0,20,20);
			p.graphics.endFill();
			
			p.alpha = 1;
			
			this.addChild(p);
			*/
			var d:DisplayObject = getDisplayContent();
									
			this.addChild(d);
			
		}
		
		/**
		 * 增加到屏幕
		 */ 
		public function Two_AddChild():void
		{
			
			//
			var srcK:IGameKing = this.srcKing;
			var targetK:IGameKing = this.targetKing;
			
			if(null == srcK ||
				null == targetK)
			{
				return;
			}
			
			var w:Number = this.width;
			var h:Number = this.height;
			
			
			/*var srcGP:Point = new Point(srcK.x,srcK.y);
			srcGP = srcK.globalToLocal(srcGP);			
			var srcLP:Point = new Point(srcK.x - srcGP.x ,srcK.y - srcGP.y);*/
			
			var targetGP:Point = new Point(targetK.x,targetK.y);
			targetGP = targetK.globalToLocal(targetGP);			
			var targetLP:Point = new Point(targetK.x - targetGP.x ,targetK.y - targetGP.y);	
						
			
			//从目标点飞到起始点
			var p:Point = WeaterEffectManager.instance.AdjustEndXY(
				targetLP.x,
				targetLP.y,
				this.targetInfo.target_height,			
				w,
				h,
				this.d_as_Movie);
						
			this.x = p.x;
			this.y = p.y;
			
			//
			//this.targetInfo.
			Two_Sub_RefreshFx();
			
			//SceneManager.instance.AddItem_Core(this);
			SceneManager.instance.AddWeater_Core(this);
						
		}
		
		public function Two_Sub_RefreshFx():void
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
					MapCl.setFangXiang(d as ResMc,this.DZ,this.FX);
					
				}else if(d as SkinBySkill)
				{
					//
					(d as SkinBySkill).setAction(this.DZ,this.FX,0,null);
					
				}
				
			}//end for	
		}
		
		
		/**
		 * 移动
		 */ 
		public function Three_Move():void
		{
			
			//
			//Three_Move_Step1();
			
			Three_Move_Bottle();
		}
		
		private function Three_Move_Bottle():void
		{
			var sk:IGameKing = this.srcKing;
			
			var roleFx:String;
			
			if(null == sk)
			{								
				roleFx = "F5";		
				
			}
			else
			{				
				roleFx = sk.roleFX;	
				
			}
			
			
			//终点
					
			//
			var mrb:MovieClip = UI_index.indexMC["mrb"];	
			var mrbGP:Point = new Point(mrb.x,mrb.y);
			mrbGP = mrb.globalToLocal(mrbGP);		
			var mrbLP:Point = new Point(mrb.x - mrbGP.x ,mrb.y - mrbGP.y);	
			
			//
			//var bottleLP:Point = new Point(mrbLP.x + 60 - 366,mrbLP.y - 40); 
			var bottleLP:Point = new Point(mrbLP.x - 315,mrbLP.y - 10); 
			
																
			//
			var p1:Point = new Point();
			
			
			switch(roleFx)
			{
				case "F1":
					
					p1.x = this.x;
					//p1.y = this.y + far;
					p1.y = this.y + ranFar;
					
					
					break;
				
				case "F2":
					
					//p1.x = this.x - far;
					//p1.y = this.y + far;
					
					p1.x = this.x - ranFar;
					p1.y = this.y + ranFar;
					
					break;
				
				
				case "F3":
					
					//p1.x = this.x - far;
					p1.x = this.x - ranFar;
					p1.y = this.y;
					
					
					break;
				
				
				case "F4":
					
					//p1.x = this.x - far;
					//p1.y = this.y - far;
					
					p1.x = this.x - ranFar;
					p1.y = this.y - ranFar;
					
					break;
				
				
				case "F5":
					
					p1.x = this.x;
					//p1.y = this.y - far;
					p1.y = this.y - ranFar;
					
					break;
				
				
				case "F6":
					
					//p1.x = this.x + far;
					//p1.y = this.y - far;
					
					p1.x = this.x + ranFar;
					p1.y = this.y - ranFar;
					
					break;
				
				
				case "F7":
					
					//p1.x = this.x + far;
					p1.x = this.x + ranFar;
					p1.y = this.y;
					
					break;
				
				
				case "F8":
					
					//p1.x = this.x + far;
					//p1.y = this.y + far;
					
					p1.x = this.x + ranFar;
					p1.y = this.y + ranFar;
					
					break;
				
				
			}
			
			
			//--------------------------------------------------------------------------------
			
			var moveTime:Number = WeaterEffectManager.SOUL_MOVE_TIME_MAX;
			
			if(this.y < WeaterEffectManager.SOUL_MOVE_DISTANCE_MIN)
			{
				moveTime = WeaterEffectManager.SOUL_MOVE_TIME_MAX;
				
			}else if(this.y < WeaterEffectManager.SOUL_MOVE_DISTANCE)
			{
				moveTime = WeaterEffectManager.SOUL_MOVE_TIME;
				
			}else if(this.y < WeaterEffectManager.SOUL_MOVE_DISTANCE_MAX)
			{
				moveTime = WeaterEffectManager.SOUL_MOVE_TIME_MIN;
			}
			
			//关掉orientToBezier,自旋转，如果中心点不在中心，会有偏差
			TweenMax.to(this, moveTime,
				{
					x:bottleLP.x, 
					y:bottleLP.y, 
					//bezier:[{x:p2.x,y:p2.y}],
					bezierThrough:[{x:p1.x,y:p1.y}],
					//orientToBezier:true,
					onComplete:this.Four_MoveComplete
				}
			);
			
			//在快到达终点，消失，透明度效果
			TweenLite.to(this, 
									moveTime/4*1, 
									{
										alpha: 0, 
										delay: moveTime/4*3,
										onComplete:Four_Sub_AlphaReset
									});
			
		}
		
		public function Four_Sub_AlphaReset():void
		{
			TweenLite.killTweensOf(this,true);
			//
			clear();
			
			this.alpha = 1.0;
			
		}
		
		/**
		 * 
		 */ 
		public function Four_MoveComplete():void
		{
			//
			clear();
			
			//刷新
			Data.myKing.dispatchEvent(new DispatchEvent(
				MyCharacterSet.SOUL_UPDATE,
				Data.myKing.Soul));
			
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
			
			bfp = FileManager.instance.getSkillSoulFileByFileName("hun_ball");					
			d =  WeaterEffectManager.instance.getPoolBySoul(bfp);
			
			return d;
		}
		
		
		//get
		
		public function get srcKing():IGameKing
		{
			var k:IGameKing = SceneManager.instance.GetKing_Core(targetInfo.srcid);
			
			return k;
		}
		
		
		public function get targetKing():IGameKing
		{
			var k:IGameKing = SceneManager.instance.GetKing_Core(targetInfo.targetid);
			
			return k;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}
	
	
}