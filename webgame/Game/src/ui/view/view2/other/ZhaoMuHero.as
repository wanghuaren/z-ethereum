package ui.view.view2.other
{
	import display.components.MoreLess;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	
	import nets.packets.PacketCSCallBlade;
	import nets.packets.PacketSCCallBlade;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;

	/**
	 *	招募英雄
	 *  2013-02-01 andy 
	 */
	public class ZhaoMuHero extends UIWindow
	{
		public function ZhaoMuHero()
		{
			super(getLink(WindowName.win_zhao_mu_ying_xiong));
		}
		
		private static var _instance : ZhaoMuHero = null;
		
		public static function get instance() : ZhaoMuHero {
			if (null == _instance)
			{
				_instance=new ZhaoMuHero();
			}
			return _instance;
		}
		
		// 面板初始化
		override protected function init():void
		{
			super.init();
			super.uiRegister(PacketSCCallBlade.id,SCCallBlade);
		}
	
		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "btnZhaoMu":
					
					var　client:PacketCSCallBlade=new PacketCSCallBlade();
					client.npc_id=30700035;
					super.uiSend(client);
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