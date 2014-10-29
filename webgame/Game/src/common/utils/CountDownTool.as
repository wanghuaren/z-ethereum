package common.utils
{
	import common.utils.clock.GameClock;
	
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import world.WorldEvent;

	/**
	 * 倒计时工具类
	 * @author steven guo
	 * 
	 */	
	public class CountDownTool
	{
		
		private var m_tf:TextField = null;
		
		//客户端剩余时间 ，毫秒
		private var m_clientRemainderTime:int = 0;
		
		//服务器剩余时间，毫秒
		private var m_serverRemainderTime:int = 0;
		
		//差值，毫秒
		private var m_differenceTime:int = 0;
		
		//绝对时间
		private var m_absoluteTime:int = 0;
		
		//是否正在运行
		private var m_isRunning:Boolean = false;
		
		
		public function CountDownTool(tf:TextField = null)
		{
			m_tf = tf;
		}
		
		public function setTF(tf:TextField):void
		{
			m_tf = tf;
		}
		
		public function start(time:int):void
		{
			updata(time);
			m_isRunning = true;
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,_onSecondTimerListener);
		}
		
		public function isRunning():Boolean
		{
			return m_isRunning;
		}
		
		public function stop():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onSecondTimerListener);
			m_isRunning = false;
		}
		
		private var m_isEn:Boolean = true;
		public function updata(time:int,isEn:Boolean = true):void
		{
			m_isEn = isEn;
			m_clientRemainderTime = time;
			m_serverRemainderTime = time;
			m_differenceTime = 0;
			m_absoluteTime = getTimer();
		}
		
		public function destroy():void
		{
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onSecondTimerListener);
			m_isRunning = false;
		}
		
		private function _onSecondTimerListener(we:WorldEvent):void
		{
			var _temp:int = getTimer();
			m_differenceTime = _temp - m_absoluteTime;
			m_clientRemainderTime = m_serverRemainderTime - m_differenceTime;
			if(m_clientRemainderTime <= 0)
			{
				m_clientRemainderTime = 0;
				stop();
				destroy();
			}

			if(null != m_tf)
			{
				m_tf.text = StringUtils.getStringDayTime(m_clientRemainderTime,m_isEn);
			}
					}
		
	}
	
	
	
	
}




