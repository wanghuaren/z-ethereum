package ui.base.mainStage
{
	import common.utils.ControlTip;
	import common.utils.clock.GameClock;
	
	import engine.load.Loadres;
	
	import netc.DataKey;
	
	import nets.packets.PacketCSGetOnlineTime;
	
	import ui.base.beibao.BeiBaoMenu;
	import ui.view.view2.other.ControlButton;
	import ui.view.view3.qiridenglulibao.QiRiDengLuLiBaoWin;
	import ui.view.view6.GameAlertNotTiShi;
	
	import world.WorldEvent;

	/**
	 *	ui_index加载完成后监听 2013-12-11
	 *  
	 */
	public class UI_index0
	{
		private static var _instance:UI_index0;
		public static function getInstance():UI_index0{
			if(_instance==null)
				_instance=new UI_index0();
			return _instance;
		}
		public function UI_index0()
		{
		}
		/**
		 *	ui_index加载后，info2文件加载完成后，初始化 
		 */
		public function startTimer():void{
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,timerHandler);
		}
		
		private function timerHandler(we:WorldEvent):void{
			if(Loadres.third_complete){
				Loadres.third_complete=false
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,timerHandler);
				init();
			}
		}
		
		//防止服务端过早发过来活动开始信息
		public static var arrDelayAction:Array=[];
		/**
		 *	代码初始化写在这里 
		 */
		private function init():void{
			//不再提示
			GameAlertNotTiShi.instance.init();
			UI_index.instance.initMcButtonArr();
			while(arrDelayAction.length>0){
				var arr:Array=arrDelayAction.pop();
				ControlButton.getInstance().checkStartTime(arr[0],arr[1]);
			}
			
			BeiBaoMenu.getInstance().initTip();
			ControlTip.getInstance().init();
			
			QiRiDengLuLiBaoWin.instance.requsetCSContinueLoginDays();//七日登录大图标 显示
			/////获取在线时间(在线奖励)
			var vo:PacketCSGetOnlineTime = new PacketCSGetOnlineTime();
			DataKey.instance.send(vo);
			
		}
	}
}