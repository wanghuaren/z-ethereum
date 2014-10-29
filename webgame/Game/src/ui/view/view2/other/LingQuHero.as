package ui.view.view2.other
{
	import display.components.MoreLess;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	
	import nets.packets.PacketCSCallBlade;
	import nets.packets.PacketSCCallBlade;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.NewMap.GameAutoPath;

	/**
	 *	领取英雄
	 *  2013-02-01 andy 
	 */
	public class LingQuHero extends UIWindow
	{
		public function LingQuHero()
		{
			super(getLink(WindowName.win_ling_qu_ying_xiong));
		}
		
		private static var _instance : LingQuHero = null;
		
		public static function get instance() : LingQuHero {
			if (null == _instance)
			{
				_instance=new LingQuHero();
			}
			return _instance;
		}
		
		// 面板初始化
		override protected function init():void
		{
			super.init();
		}
	
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "btnLingQu":
				case "btnLingQu1":
					GameAutoPath.seek(30100062);
					winClose();
					break;
				case "btnChuan":
					GameAutoPath.chuan(30100062);
					winClose();
					break;

			}
		}
		
		private function SCCallBlade(p:PacketSCCallBlade):void{
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