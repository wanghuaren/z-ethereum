package ui.base.zudui
{
	import common.utils.clock.GameClock;
	
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import nets.packets.PacketCSPlayerLeaveInstance;

	import org.osmf.events.TimeEvent;

	import ui.frame.UIWindow;

	import common.managers.Lang;
	import world.WorldEvent;

	//踢出副本的倒计时
	//你已被踢出队伍，#param秒后将被传出副本！
	public class JiShi extends UIWindow
	{
		private var jishi:int;
		
		public function JiShi()
		{
			super(getLink("pop_jishi"));
		}

		private static var _instance:JiShi=null;

		public static function get instance():JiShi
		{
			if (null == _instance)
			{
				_instance=new JiShi();
			}
			return _instance;
		}

		// 面板初始化
		override protected function init():void
		{
			super.init();
			jishi = 60;
			
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,timeEvent);
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,timeEvent);
		}
		
		//private function timeEvent(e:TimerEvent):void{
		private function timeEvent(e:WorldEvent):void{
		
			jishi--;
			mc["msg"].text=Lang.getLabel("20020_JiShi", [jishi + ""]);
			if (jishi < 1)
			{
				mcHandler({name: "tuichu"});
			}
		}

		// 面板点击事件
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "tuichu":
					
					GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,timeEvent);
					
					var vo2:PacketCSPlayerLeaveInstance = new PacketCSPlayerLeaveInstance();
					vo2.flag = 1;
					uiSend(vo2);
					winClose();
					break;
			}
		}

		// 窗口关闭事件
		override protected function windowClose():void
		{
			super.windowClose();
						
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,timeEvent);
		}
	}
}