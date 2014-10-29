package common.utils.clock
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import netc.MsgPrint;
	import netc.MsgPrintType;

	public class GameMainTimer
	{
		
		
		private static var _clockEventDispatcher:EventDispatcher = new EventDispatcher();
				
		/**
		 * 事件派发器
		 */
		public static function get ClockEventDispatcher():EventDispatcher
		{
			return _clockEventDispatcher;
		}

		/**
		 * GameData中调用
		 * 这个还是要用timer
		 */ 
		private static var _t:Timer;
		
		public static function get T():Timer
		{
			if(null == _t)
			{
				_t = new Timer(800);//1000);				
			}
			
			return _t;
		}
		
		
		public static function run():void
		{
			//切换地图还要清理内存
			//还是用1秒的好，稳定		
			T.stop();
			T.reset();
			
			//
			T.removeEventListener(TimerEvent.TIMER,clockTimerHandler);
			T.addEventListener(TimerEvent.TIMER,clockTimerHandler);
			T.start();			
		}
		
		public static function stop():void
		{
			T.stop();	
			
			T.removeEventListener(TimerEvent.TIMER,clockTimerHandler);
		}
		private static var dispathTimeEvent:TimerEvent=new TimerEvent(TimerEvent.TIMER);
		private static function clockTimerHandler(event:TimerEvent):void
		//private static function clockTimerHandler(event:WorldEvent):void
		{
			//Debug.instance.traceMsg("clockTimerHandler");
			
			//更高的优先级						
			//如果停止则开始加载怪物
			//如果有怪物攻击本人，则开始加载该怪物
			//优先加载怪物
			try
			{
								
//				_clockEventDispatcher.dispatchEvent(new TimerEvent(TimerEvent.TIMER));
				_clockEventDispatcher.dispatchEvent(dispathTimeEvent);
		
			}catch(err:Error)
			{
				MsgPrint.printTrace(err.message + 
					" Func:clockTimerHandler Class:GameMainTimer",MsgPrintType.TIMER_TICK);
				
			}
		}
	}
}