package ui.view.view1.fuben.area
{
	import common.utils.StringUtils;
	import common.utils.clock.GameClock;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import model.fuben.FuBenEvent;
	import model.fuben.FuBenModel;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.WorldEvent;
	
	public class BossRefreshTip extends UIWindow
	{
		private static var _instance:BossRefreshTip = null;
		
		//当前剩余时间,已毫秒计算。
		public var m_currrentTime:int = 0;
		
		public function BossRefreshTip()
		{
			super(getLink(WindowName.win_boss_dao_ji_shi));
		}
		
		public static function getInstance():BossRefreshTip{
			if (_instance == null){
				_instance = new BossRefreshTip();
			}
			return _instance;
		}
		
		/**
		 * 面板开启的时候初始化面板数据内容 
		 * 
		 */		
		override protected function init():void
		{
			super.init();
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,_onGameClockListner);
			
			if(null != stage)
			{
				stage.addEventListener(Event.RESIZE, _resizeHandler);
			}
			
			replace();
		}
		
		override public function winClose():void
		{
			super.winClose();
			
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onGameClockListner);
			
			if(null != stage)
			{
				stage.removeEventListener(Event.RESIZE, _resizeHandler);
			}
		}
		
		private function _onGameClockListner(e:WorldEvent=null):void
		{
			if(m_currrentTime<0)
			{
				return ;
			}
			
			var _t:int = _countTime()*0.001;
			
			//剩余时间
			mc["cdTime"].text = _t.toString();
			
			//			0007526: 活动倒计时：倒计时结束时面板仍然存在 
			//			描述 活动结束，倒计时也结束时，倒计时面板没有消失，显示00：00
			//			预期：活动结束时自动关闭倒计时面板。 
			if(_t <= 0)
			{
				winClose();
			}
		}
		
		/**
		 * 设置倒计时 
		 * @param time   毫秒
		 * 
		 */		
		public function setTime(time:int):void
		{
			m_atSetTime = getTimer();
			m_currrentTime = time;
		}
		
		
		//与服务器同步的时候节点
		private var m_atSetTime:int;
		/**
		 * 计算一下剩余时间，返回毫秒值 
		 * @return 
		 * 
		 */		
		public function _countTime():int
		{
			var _t:int = m_currrentTime - (getTimer() - m_atSetTime);
			
			if(_t <= 0)
			{
				_t = 0;
			}
			
			return _t;
		}
		
		/**
		 * 重新布局 
		 * 
		 */		
		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标
		private function replace():void
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
				m_gPoint.x = ( (mc.stage.stageWidth - mc.width ) >> 1 );
				m_gPoint.y = 65; //( (mc.stage.stageHeight - mc.height)>> 1 ) - 180;
				
				m_lPoint = mc.parent.globalToLocal(m_gPoint);
				
				mc.x = m_lPoint.x;
				mc.y = m_lPoint.y;
			}
			
			
		}
		
		private function _resizeHandler(event:Event):void 
		{
			
			if(null != mc && null != mc.parent && null != mc.stage)
			{
				replace();
			}
			
		}
		
		override public function closeByESC():Boolean
		{
			return false;
		}
	}
}