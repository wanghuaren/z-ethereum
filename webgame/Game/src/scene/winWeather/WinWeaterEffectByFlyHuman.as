package scene.winWeather
{
	import common.utils.clock.GameClock;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Point;
	
	import netc.Data;
	
	import scene.event.KingActionEnum;
	import scene.king.FlyKing;
	import scene.king.IGameKing;
	import scene.skill2.SkillEffect121ByYJF;
	import scene.skill2.SkillEffectManager;
	
	import ui.frame.UIWindow;
	
	import world.FileManager;
	import world.WorldEvent;
	import world.model.file.BeingFilePath;
	import world.type.BeingType;
	import world.type.WorldType;
	
	public class WinWeaterEffectByFlyHuman extends UIWindow
	{
		private static var _instance:WinWeaterEffectByFlyHuman;
		
		public static function getInstance():WinWeaterEffectByFlyHuman
		{
			if (null == _instance)
			{
				_instance=new WinWeaterEffectByFlyHuman();
			}
			
			return _instance;
		}
		
		/**
		 * 一维数组
		 */ 
		public var flyKingList:Array;
		
		public function WinWeaterEffectByFlyHuman()
		{
			var DO:DisplayObject = new McWeaterEffectByFlyHuman();
			
			super(DO, null, 1, false);
		}
		
		public function init2():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK__,frameHandler);
			clear();
			flyKingList = [];
			
			//
			this._replace();
			init();
		}
		
		override protected function init():void
		{
			var _g:Graphics = this.graphics;
			
			_g.clear();
			
			_g.beginFill(0xFFFFFF,0.0);//1.0, 0.0
			_g.drawRect(0, 0, 200, 200);
			_g.endFill();
			
			//不可点击，以免引起child变化,uiwindow基本规则：点了后调到最上层
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			//
			flyKingList = [];
			
			//
			One_CreateEffect();
			
			//
			GameClock.instance.addEventListener(WorldEvent.CLOCK__,frameHandler);
			frameHandler();
			
					}
		
		public function frameHandler(e:Event=null):void
		{
			//只用调方向，动作待机
			var roleDZ:String = KingActionEnum.DJ;
			
			var roleFX:String = Data.myKing.king.roleFX;
			
			//持续地设置
			Data.myKing.king.visible = false;
			
			//
			Two_Sub_RefreshFx(roleDZ,roleFX);
					}
		
		/**
		 * 创建效果文件
		 */ 
		public function One_CreateEffect():void
		{
			
			var flyK:FlyKing = new FlyKing();
			
			//copy 
			var myK:IGameKing = Data.myKing.king;
			
			//data
			flyK.name=WorldType.WORLD + myK.roleID.toString();
			flyK.name2=BeingType.HUMAN + myK.roleID.toString();
			
			flyK.setKingData(
				
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
			
			flyK.setKingSkin(bfp);
			
			//
			//flyK.scaleX = 1 + (1 - Action.instance.yuJianFly.YuJianFlyRate);
			//flyK.scaleY = 1 + (1 - Action.instance.yuJianFly.YuJianFlyRate);
			
			
			//
			flyKingList.push(flyK);
			
			//
			Two_AddChild();
			
		}
		
		/**
		 * 增加到屏幕
		 */ 
		public function Two_AddChild():void
		{
			var jLen:int = flyKingList.length;
			
			for(var j:int =0;j < jLen;j++)
			{
				this.addChild(flyKingList[j]);
				
				//effect
				var se_yjf_sword:SkillEffect121ByYJF = new SkillEffect121ByYJF();
				se_yjf_sword.setData(flyKingList[j],"yjf_sword");
				SkillEffectManager.instance.send(se_yjf_sword);
			
			}
			
			
		
		}		
		
	
		
		public function Two_Sub_RefreshFx(DZ:String,FX:String):void
		{	
			//loop use
			var i:int;
			
			//调整方向
			var flyK:FlyKing;	
			
			for(var j:int =0;j<flyKingList.length;j++)
			{
				flyK = flyKingList[j];
				
				flyK.x = 0;
				flyK.y = 0;
				
				flyK.visible = true;
				
				flyK.alpha = 1.0;
				
				flyK.setKingAction(DZ,FX);				
			
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
			var len:int = this.numChildren;
			var d:DisplayObject;
			
			for(var i:int=0;i<len;i++)
			{
				d = this.removeChildAt(0);
				
			}
			
		}
		
		public function winClose2():void
		{
			windowClose();
		}
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			flyKingList = [];
			
			Four_MoveComplete();
				
		
			GameClock.instance.removeEventListener(WorldEvent.CLOCK__,frameHandler);
			
			super.windowClose();
			
						
		}
		
		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标
		private function _replace():void
		{
			
			if(null == m_gPoint)
			{
				m_gPoint = new Point();
				
			}
			
			if(null == m_lPoint)
			{
				m_lPoint = new Point();
			}
			
			if(null != this.parent && null != this.stage)
			{
				m_gPoint.x = (this.stage.stageWidth - 20 ) >> 1 ;
				m_gPoint.y = this.stage.stageHeight /2;
				
				m_lPoint = this.parent.globalToLocal(m_gPoint);
				
				this.x = m_lPoint.x;
				this.y = m_lPoint.y;
			}
			
			
		}
		
		override public function closeByESC():Boolean
		{
			return false;
		}
		
	}
}