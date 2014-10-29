package ui.view.view1.fuben
{
	import common.utils.clock.GameClock;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.WorldEvent;
	
	
	/**
	 * 失败特效，常用于副本中。
	 * @author steven guo
	 * 
	 */	
	public class FailedEffect extends UIWindow
	{
		
		private static var _instance : FailedEffect = null;
		
		private static const COUNT_DOWM_NUM:int = 5;
		
		public function FailedEffect()
		{
			super(getLink(WindowName.win_huodong_Failed_Effect));
		}
		
		
		
		public static function getInstance() : FailedEffect {
			if (null == _instance)
			{
				_instance=new FailedEffect();
			}
			return _instance;
		}
		
		
		// 面板初始化
		override protected function init():void
		{
			super.init();
			
			_replace();
			
			//增加倒计时
			m_clock = 0;
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onClockListener);					
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,_onClockListener);	
		
			(mc as MovieClip).gotoAndPlay(1);
		}
		
		private var m_clock:int = 0;
		private function _onClockListener(e:WorldEvent):void
		{
			if(m_clock > COUNT_DOWM_NUM )
			{
				winClose();
			}
			
			++m_clock;
		}
		
		override public function winClose():void
		{
			super.winClose();
			
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onClockListener);	
		}
		
		
		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标
		private function _replace():void
		{
			
			if(null == m_gPoint)
			{
				m_gPoint = new Point();
				
			}
			
			if(null == m_lPoint)
			{
				m_lPoint = new Point();
			}
			
			if(null != mc && null != mc.parent && null != mc.stage)
			{
				m_gPoint.x = (mc.stage.stageWidth - mc.width ) >> 1 ;
				m_gPoint.y =( (mc.stage.stageHeight - mc.height)>> 1 ) - 100;
				
				m_lPoint = mc.parent.globalToLocal(m_gPoint);
				
				mc.x = m_lPoint.x;
				mc.y = m_lPoint.y;
			}
			
		}
		
	}
	
	
	
}




