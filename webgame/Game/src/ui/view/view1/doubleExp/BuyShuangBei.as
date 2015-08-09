package ui.view.view1.doubleExp
{
	import display.components.MoreLess;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	
	import nets.packets.PacketCSDoubleExpAddTime;
	
	import ui.frame.UIWindow;
	
	public class BuyShuangBei extends UIWindow
	{
		private var duihuan:int = 20;
		public function BuyShuangBei()
		{
			super(getLink("win_goumaishuangbei"));
		}
		
		private static var _instance : BuyShuangBei = null;
		
		public static function get instance() : BuyShuangBei {
			if (null == _instance)
			{
				_instance=new BuyShuangBei();
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
					var vo:PacketCSDoubleExpAddTime = new PacketCSDoubleExpAddTime();
					vo.hour = mc["ui_count"].value;
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