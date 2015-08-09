package ui.view.view1.doubleExp
{
	import display.components.MoreLess;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	
	import nets.packets.*;
	import netc.packets2.*;
	
	import ui.frame.UIWindow;
	
	public class BuyFuBenTime extends UIWindow
	{
		private var duihuan:int = 20;
		public function BuyFuBenTime()
		{
			super(getLink("win_goumaifuben"));
		}
		
		private static var _instance : BuyFuBenTime = null;
		
		public static function get instance() : BuyFuBenTime {
			if (null == _instance)
			{
				_instance=new BuyFuBenTime();
			}
			return _instance;
		}
		
		// 面板初始化
		override protected function init():void
		{
			super.init();
			mc["yuanbao"].text = int(mc["ui_count"].value)*duihuan+"";
			mc["ui_count"].addEventListener(MoreLess.CHANGE,count_change);
		}
		
		private function count_change(e:DispatchEvent):void{
			mc["yuanbao"].text = int(e.getInfo.count)*duihuan+"";
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
					var vo:PacketCSBuyNewExpLastTime = new PacketCSBuyNewExpLastTime();
					vo.buy_num = mc["ui_count"].value;
					uiSend(vo);
					winClose();
					break;
			}
		}
		
		// 窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();
		}
	}
}