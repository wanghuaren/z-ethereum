package scene.winWeather
{
	import common.utils.clock.GameClock;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	
	import netc.Data;
	
	import scene.event.KingActionEnum;
	import scene.king.IGameKing;
	import scene.king.JumpKing;
	
	import ui.frame.UIWindow;
	
	import world.FileManager;
	import world.WorldEvent;
	import world.model.file.BeingFilePath;
	import world.type.BeingType;
	import world.type.WorldType;
	
	public class WinWeaterEffectByJumpHuman extends UIWindow
	{
		private static var _instance:WinWeaterEffectByJumpHuman;
		
		public static function getInstance():WinWeaterEffectByJumpHuman
		{
			if (null == _instance)
			{
				_instance=new WinWeaterEffectByJumpHuman();
			}
			
			return _instance;
		}
		
		/**
		 * 一维数组
		 */ 
		public var jumpKingList:Array;
		
		public function WinWeaterEffectByJumpHuman()
		{
			var DO:DisplayObject = new McWeaterEffectByFlyHuman();
			
			super(DO, null, 1, false);
		}
		
		override protected function init():void
		{
			//
			this.alpha = 0.0;
			
			var _g:Graphics = this.graphics;
			
			_g.clear();
			
			_g.beginFill(0xFFFFFF,0.0);//1.0, 0.0
			_g.drawRect(0, 0, 20, 20);
			_g.endFill();
			
			//不可点击，以免引起child变化,uiwindow基本规则：点了后调到最上层
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			//
			jumpKingList = [];
			
			//
			One_CreateEffect();
			
			//
			GameClock.instance.addEventListener(WorldEvent.CLOCK__,frameHandler);
			
		}
		
		public function frameHandler(e:Event):void
		{
			//只用调方向，动作待机
			var roleDZ:String = KingActionEnum.JP;
			
			var roleFX:String = "F1";
			
			if(null != Data.myKing.king)
			{
				roleFX = Data.myKing.king.roleFX;
			}
			//持续地设置
			
			
			//
			Two_Sub_RefreshFx(roleDZ,roleFX);
			
		}
		
		/**
		 * 创建效果文件
		 */ 
		public function One_CreateEffect():void
		{
			//copy 
			var myK:IGameKing = Data.myKing.king;
			
			if(null == myK)
			{
				return;
			}
			
			var jumpK:JumpKing = new JumpKing();			
			
			//data
			jumpK.name=WorldType.WORLD + myK.roleID.toString();
			jumpK.name2=BeingType.HUMAN + myK.roleID.toString();
			
			jumpK.setKingData(
				
				myK.roleID,myK.objid,myK.getKingName,myK.sex,myK.metier,
				myK.level,myK.hp,myK.maxHp,myK.camp,myK.campName,myK.mapx,
				myK.mapy,myK.masterId,myK.masterName,myK.mapZoneType,myK.grade
				
			);
			
			//skin
			var myBfp:BeingFilePath = myK.getSkin().filePath.clone();
			
			var bfp:BeingFilePath = FileManager.instance.getMainByHumanId(						
				0,
				0,
				myBfp.s2,
				myBfp.s3,
				myK.sex);	
			
			jumpK.setKingSkin(bfp);
			
			//
			//jumpK.scaleX = 1 + (1 - Action.instance.yuJianFly.YuJianFlyRate);
			//jumpK.scaleY = 1 + (1 - Action.instance.yuJianFly.YuJianFlyRate);
			
			
			//
			jumpKingList.push(jumpK);
			
			//
			Two_AddChild();
			
		}
		
		/**
		 * 增加到屏幕
		 */ 
		public function Two_AddChild():void
		{
			var jLen:int = jumpKingList.length;
			
			for(var j:int =0;j < jLen;j++)
			{
				this.addChild(jumpKingList[j]);
							
			}
			
			
			
		}		
		
		
		
		public function Two_Sub_RefreshFx(DZ:String,FX:String):void
		{	
			//loop use
			var i:int;
			
			
			//调整方向
			var jumpK:JumpKing;	
			
			for(var j:int =0;j<jumpKingList.length;j++)
			{
				jumpK = jumpKingList[j];
				
				jumpK.setKingAction(KingActionEnum.JP,FX);				
				
			}//end for	
			
		}
		
		/**
		 * 
		 */ 
		public function Four_MoveComplete():void
		{
			//
			clear();
			
			
		}
		
		/**
		 * 窗体clear，注意是this.mc.numChildren
		 */ 
		public function clear():void
		{
			var len:int = this.mc.numChildren;
			var d:DisplayObject;
			
			for(var i:int=0;i<len;i++)
			{
				d = this.mc.removeChildAt(0);
			}
			
		}
		
		
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			jumpKingList = [];
			
			Four_MoveComplete();
			
			
			GameClock.instance.removeEventListener(WorldEvent.CLOCK__,frameHandler);
			
			super.windowClose();
			
		}
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
	}
}