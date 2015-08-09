package ui.view.view2.other
{
	import display.components.MoreLess;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	
	import nets.packets.PacketCSBuyNewExpLastTime;
	import nets.packets.PacketCSDoubleExpAddTime;
	import nets.packets.PacketSCBuyNewExpLastTime;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;

	/**
	 *	购买高级经验副本时间
	 *  2013-02-01 andy 
	 */
	public class BuyExpTime extends UIWindow
	{
		private var duihuan:int = 30;
		public function BuyExpTime()
		{
			super(getLink(WindowName.win_buy_exp_time));
		}
		
		private static var _instance : BuyExpTime = null;
		
		public static function get instance() : BuyExpTime {
			if (null == _instance)
			{
				_instance=new BuyExpTime();
			}
			return _instance;
		}
		
		// 面板初始化
		override protected function init():void
		{
			super.init();
			mc["txt_yuanbao"].text = int(mc["ui_count"].value)*duihuan+"";
			mc["ui_count"].addEventListener(MoreLess.CHANGE,count_change);
		}
		
		private function count_change(e:DispatchEvent):void{
			mc["txt_yuanbao"].text = int(e.getInfo.count)*duihuan+"";
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "btnclose":
					winClose();
					break;
				case "btnSubmit":
					super.uiRegister(PacketSCBuyNewExpLastTime.id,SCBuyNewExpLastTimeReturn);
					var vo:PacketCSBuyNewExpLastTime= new PacketCSBuyNewExpLastTime();
					vo.buy_num = mc["ui_count"].value;
					uiSend(vo);
					break;
			}
		}
		
		private function SCBuyNewExpLastTimeReturn(p:PacketSCBuyNewExpLastTime):void{
			if(super.showResult(p)){
				winClose();
			}else{
			
			}
		}
		// 窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();
		}
	}
}