package ui.base.huodong
{
	import common.config.xmlres.XmlManager;
	import common.config.xmlres.server.Pub_AchievementResModel;
	import common.config.xmlres.server.Pub_Limit_TimesResModel;
	import common.utils.CtrlFactory;
	import common.utils.StringUtils;
	import common.utils.component.ToolTip;
	
	import engine.event.DispatchEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import netc.Data;
	import netc.packets2.StructActRecList2;
	import netc.packets2.StructActivityPrizeInfo2;
	import netc.packets2.StructBagCell2;
	import netc.packets2.StructPrizeInfo2;
	
	import nets.packets.PacketCSGetActivityTool;
	import nets.packets.PacketSCGetActivityPrize;
	import nets.packets.PacketSCGetActivityTool;
	import nets.packets.StructActivityPrizeInfo;
	
	import ui.frame.ImageUtils;
	import ui.frame.ItemManager;
	import ui.frame.UIWindow;
	
	import world.FileManager;
	
	public class HuoDongPrize extends UIWindow
	{
		/**
		 * 结果
		 */ 
		public var resultX:int = 0;
		public var currX:int = 0;
		public var turnPhotoStep:int = 1;
		
		/**
		 * 开始转
		 */ 
		private var _turnTimer:Timer;
		private var _turnTimer2:Timer;
		//private var _turnLvl:int;
		
		
		
				
		private static var _instance:HuoDongPrize;		
		
		/**
		 * 	@param must 是否必须 
		 */
		public static function instance():HuoDongPrize
		{
			if(_instance==null)
			{
				_instance=new HuoDongPrize();
			}
			return _instance;
		}
		
		public function HuoDongPrize(d:Object=null)
		{
			//blmBtn=3;
			super(getLink("pop_prize"),d);
		}
		
		//面板初始化
		override protected function init():void 
		{			
			//super.sysAddEvent(mc_content,MouseEvent.MOUSE_OVER,overHandle);
			
			reset();
		}
	
		
		private function overHandle(e:MouseEvent):void{
			var nm:String=e.target.name;
			if(nm.indexOf("item")==0){
				//var itemData:StructFriendData2=e.target.data;
				//e.target.tipParam=[itemData.rolename,itemData.jobName,itemData.level,""];
			}
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			
			var target_name:String = target.name;
			
			//获得奖励按钮已被删除
			/*switch (target_name)
			{
				case "btnSubmit":
					
					this.uiRegister(PacketSCGetActivityTool.id, btnJiangLiReturn);					
					var client1:PacketCSGetActivityTool=new PacketCSGetActivityTool();	
					client1.seqid = this.seqid;
					this.uiSend(client1);	
					
					break;
			}*/
		
		}
		
		
		private function btnJiangLiReturn(p:PacketSCGetActivityTool):void
		{
			if (super.showResult(p))
			{	
				//this.windowClose();
				this.winClose();
			}
			else
			{
				//this.windowClose();
				this.winClose();
			}
		}
		
		
		public var itemList:Vector.<StructBagCell2> = new Vector.<StructBagCell2>();
		
		/**
		 * 兑奖序列号
		 */ 
		public var seqid:int;
		
		
		public function btnStartClick(p:PacketSCGetActivityPrize):void
		{				
			
			//---------------------------------------------------------------------
			var i:int;
			var len:int = itemList.length;
			
			for(i =0;i<len;i++)
			{
				itemList.pop();
			}
			
			//
			len = p.arrItemprizelist.length;
			
			for(i=0;i<len;i++)
			{
				var bag:StructBagCell2 = new StructBagCell2();
				bag.itemid = p.arrItemprizelist[i].toolid;
				bag.num = p.arrItemprizelist[i].toolnum;
				//bag.pos = i+1;
				bag.pos = 0;
				bag.huodong_pos = i+1;
				
				//
				Data.beiBao.fillCahceData(bag);
				
				//
				itemList.push(bag);
			}
			
			
			//showList
			showPackage();
			
			//----------------------------------------------------------------------
			
			
			len = itemList.length;
			for(i=0;i<len;i++)
			{
				if(itemList[i].itemid == p.prizeid)
				{
					resultX = i + 1;
					break;
				}
			}
			
			seqid = p.seqid;
			
			turn();
		}		
		
		private function turn():void
		{			
			resetTurnTimer();
			getTurnTimer().start();			
		}
		
		
		
		
		
		/**
		 * for end
		 */ 
		public function  getTurnTimer2():Timer
		{
			if(null == _turnTimer2)
			{
				_turnTimer2 = new Timer(60);
				//_turnTimer2 = new Timer(120);
				_turnTimer2.addEventListener(TimerEvent.TIMER,turnTimer2Handler);				
			}
			
			return _turnTimer2;
		}
		
		public function turnTimerHandler(event:TimerEvent):void
		{
			if(_turnTimer.currentCount < 10)
			{
				if((_turnTimer.currentCount % 2) == 0 || 
					_turnTimer.currentCount == 0 || 
					_turnTimer.currentCount == 1)
				{
					turnPhotoStep = 1;
					
				}else
				{
					turnPhotoStep = 0;
				}
				
			}else if(_turnTimer.currentCount < 40)
			{
				turnPhotoStep = 1;
				
			}else if(_turnTimer.currentCount < 50)
			{
				turnPhotoStep = 2;
				
			}else if(_turnTimer.currentCount < 60)
			{
				turnPhotoStep = 1;
				
			}else
			{
				if((_turnTimer.currentCount % 4) == 0)
				{
					turnPhotoStep = 1;
					
				}else
				{
					turnPhotoStep = 0;
				}
			}
			
			turnPhoto();
		}
		
		public function turnTimerCompleteHandler(event:TimerEvent):void
		{			
			turnPhotoEnd();
		}
		
		/**
		 * tiQianJianSu = 提前减速
		 */ 
		public function turnPhotoEnd():void
		{	
			
			//
			getTurnTimer().stop();
			
			//
			if(getTurnTimer2().running)
			{
				return;
			}
			
			getTurnTimer2().start();
			
			
		}
		
		public function turnTimer2Handler(e:TimerEvent):void
		{
			if(currX != this.resultX)
			{
				if((_turnTimer2.currentCount % 4) == 0)
				{
					turnPhotoStep = 1;
					
				}else
				{
					turnPhotoStep = 0;
				}
				
				turnPhoto();
				
			}else
			{
				getTurnTimer2().stop();
				//
				turnEnd();
			}
		}
		
		public function turnEnd():void
		{
			//zhong框略大，x,y需减2像素
			mc["zhong"].x = mc["item" + this.resultX.toString()].x - 2;
			mc["zhong"].y = mc["item" + this.resultX.toString()].y - 2;
			mc["zhong"].visible = true;
			mc["zhong"].gotoAndPlay(1);
			
			//StringUtils.setEnable(mc["btnSubmit"]);
			this.mcHandler({name:"btnSubmit"});
			
			//
			setTimeout(delayWinClose,3000);
			
		}
		
		public function delayWinClose():void
		{
			this.winClose();		
		}
				
		public function turnPhoto():void
		{
			this.currX = this.currX + turnPhotoStep;
			
			if(this.currX == 0)
			{
				this.currX = 1;
			}
			
			if(this.currX > 8)
			{
				this.currX = 1;
			}
			
			for(var i:int=1;i<=8;i++)
			{
				if(i != currX)
				{
					mc["fan" + i.toString()].visible = false;
				}
			}
			
			mc["fan" + currX.toString()].visible = true;
		}
		
		public function  getTurnTimer():Timer
		{
			if(null == _turnTimer)
			{
				//第一档 慢 10
				//第二档 稍快 10
				//第三档 快 20
				//第四档 慢 10
				
				//转5秒后变慢,则为 80 + 20
				_turnTimer = new Timer(60,50);
				//_turnTimer = new Timer(120,50);
				_turnTimer.addEventListener(TimerEvent.TIMER,turnTimerHandler);
				_turnTimer.addEventListener(TimerEvent.TIMER_COMPLETE,turnTimerCompleteHandler);
				
			}
			
			return _turnTimer;
		}
		
		
		public function resetTurnTimer():void
		{
			getTurnTimer().reset();
		}
		
		/**
		 * 第一次弹出面板，或提取货物成功后调用此方法
		 */ 
		private function reset():void
		{
			resultX = 0;
			
			currX = 0;
			
			turnPhotoStep = 1;
			
			//
			resetTurnTimer();
			
			
			//
			(mc["zhong"] as MovieClip).mouseEnabled = (mc["zhong"] as MovieClip).mouseChildren = false;
			(mc["zhong"] as MovieClip).visible = false;			
			(mc["zhong"] as MovieClip).gotoAndStop(1);
			
			//
			for(var i:int=1;i<=8;i++)
			{
				mc["fan" + i.toString()].mouseEnabled = mc["fan" + i.toString()].mouseChildren = false;
				mc["fan" + i.toString()].visible = false;
			}
			
			//
			clearItem();
			
			//
			//StringUtils.setUnEnable(mc["btnSubmit"]);
			
		}
		
		
		
		/**
		 *	物品列表 
		 */
		private function showPackage(ds:DispatchEvent=null):void{
			clearItem();
			
			var arr:Array = [];
			
			var len:int =  this.itemList.length;	
			for(var i:int=0;i<len;i++)
			{			
				arr.push(this.itemList[i]);
			}
			
			//arr.sortOn("pos");
			arr.sortOn("huodong_pos");
			arr.forEach(callback);
			ToolTip.instance().resetOver();
		}
				
		//列表中条目处理方法
		private function callback(itemData:StructBagCell2,index:int,arr:Array):void {
			//var pos:int=itemData.pos;
			var pos:int= itemData.huodong_pos;
			var sprite:*=mc.getChildByName("item"+pos);
			if(sprite==null)return;
			sprite.mouseChildren=false;
			sprite.data=itemData;
			
			ItemManager.instance().setEquipFace(sprite);
			
//			sprite["uil"].source=itemData.icon;
			ImageUtils.replaceImage(sprite,sprite['uil'],itemData.icon);
			sprite["r_num"].text=itemData.sort==13?"":itemData.num;
			CtrlFactory.getUIShow().addTip(sprite);
			//new MainDrag(sprite,null);
		}
		
		/**
		 *	换页时清理格子数据 
		 * 
		 * 48是每页的格子数
		 */
		private function clearItem():void{
			var _loc1:*;
			var len:int = 8;
			
			for(i=1;i<=len;i++){
				_loc1=mc.getChildByName("item"+i);
				_loc1["uil"].unload();
				_loc1["r_num"].text="";
				_loc1.mouseChildren=false;
				_loc1.data=null;
				ItemManager.instance().setEquipFace(_loc1,false);
			}
		}
		
		override public function winClose() : void 
		{
			
			if(null != _turnTimer)
			{
				_turnTimer.stop();
				_turnTimer.removeEventListener(TimerEvent.TIMER,turnTimerHandler);
				_turnTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,turnTimerCompleteHandler);
				_turnTimer = null;
			}
			
			if(null != _turnTimer2)
			{
				_turnTimer2.stop();
				_turnTimer2.removeEventListener(TimerEvent.TIMER,turnTimer2Handler);	
				_turnTimer2 = null;
			}
			
			// 面板关闭事件
			super.winClose();
		}
		
		
		
		
		
		
		
		
		
		
	}
}