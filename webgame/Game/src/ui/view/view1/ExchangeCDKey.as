package ui.view.view1
{
	import flash.display.DisplayObject;
	
	import nets.packets.PacketCSExchangeCDKey;
	import nets.packets.PacketSCExchangeCDKey;
	
	import ui.frame.UIWindow;
//兑换CDKey礼包
	public class ExchangeCDKey extends UIWindow
	{
		
		public function ExchangeCDKey()
		{
			super(getLink("win_dui_libao"));
		}
		
		private static var _instance : ExchangeCDKey = null;
		
		public static function get instance() : ExchangeCDKey {
			if (null == _instance)
			{
				_instance=new ExchangeCDKey();
			}
			return _instance;
		}
		
		// 面板初始化
		override protected function init():void
		{
			super.init();
			uiRegister(PacketSCExchangeCDKey.id,SCExchangeCDKey);
		}
		
		private function SCExchangeCDKey(p:PacketSCExchangeCDKey) : void {
			if(showResult(p)){
				winClose();
			}
		}
		
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "submit":
					var vo:PacketCSExchangeCDKey = new PacketCSExchangeCDKey();
					vo.cdkey = mc["txt"].text;
					uiSend(vo);
					break;
				case "cancel":
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