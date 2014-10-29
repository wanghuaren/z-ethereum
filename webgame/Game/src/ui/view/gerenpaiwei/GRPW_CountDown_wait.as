package ui.view.gerenpaiwei
{
	import common.managers.Lang;
	import common.utils.CountDownTool;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import model.gerenpaiwei.GRPW_Event;
	import model.gerenpaiwei.GRPW_Model;
	
	import netc.Data;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	public class GRPW_CountDown_wait extends UIWindow
	{
		
		private static var m_instance:GRPW_CountDown_wait;
		
		private var m_model:GRPW_Model = null;
		
		public function GRPW_CountDown_wait()
		{
			//TODO: implement function
			super(getLink(WindowName.win_GRPW_CountDown_wait));
			m_model = GRPW_Model.getInstance();
			m_model.addEventListener(GRPW_Event.GRPW_EVENT, _processEvent);
			
			
			canDrag = false;
			
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		private function _processEvent(e:GRPW_Event):void
		{
			var _sort:int=e.sort;
			
			switch(_sort)
			{
				case GRPW_Event.GRPW_EVENT_SORT_NEXT_MATCH_TIME:
					_repaint();
					break;
				default:
					break;
			}

		}
		
		public static function getInstance():GRPW_CountDown_wait
		{
			if (null == m_instance)
			{
				m_instance= new GRPW_CountDown_wait();
			}
			return m_instance;
		}
		
		public function Stage_resize(event:Event=null):void
		{
			replace();
		}
		
		private var m_gPoint:Point; //全局坐标
		private var m_lPoint:Point; //本地坐标
		public function replace():void
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
				m_gPoint.y = 30;//mc.stage.stageHeight - 230;
				
				m_lPoint = mc.parent.globalToLocal(m_gPoint);
				
				mc.x = m_lPoint.x;
				mc.y = m_lPoint.y;
			}
		}
		
		
		
		override public function winClose():void
		{
			super.winClose();
			
			if (null != this.m_countDownTool)
			{
				this.m_countDownTool.stop();
			}
		}
		
		
		override protected function init():void 
		{
			super.init();
			
			this.stage.addEventListener(Event.RESIZE, this.Stage_resize);

			
			
			
			_initCom();
			replace();
			
			_repaint();

		}
		
		
		private function _initCom():void
		{
			mc['mcFighting']['tf_start_time'].text = "";
			mc['mcFighting']['tf_remainderTime'].text = "";
		}
		
		
		
		//倒计时工具对象
		private var m_countDownTool:CountDownTool=null;
		private function _repaint():void
		{
			if(null == mc)
			{
				return ;
			}
			
			if(m_model.isLastMatch())
			{
				mc['mcFighting'].visible = false;
				mc['mcLastMatch'].visible = true;
			}
			else
			{
				mc['mcFighting'].visible = true;
				mc['mcLastMatch'].visible = false;
			}
			
			
			//当前服务器时间
			var _serverDate:Date = Data.date.nowDate;
			
			trace("当前服务器时间 -> " + _serverDate.toString());
			
			//下一场开始时间
			var _nextMatchDate:Date = new Date();
			_nextMatchDate.time = m_model.getNextMatchTime();
			trace("下一场开始时间 -> " + _nextMatchDate.toString());
			
			
//			var _nextMatchDateString:String = _nextMatchDate.hours + Lang.getLabel("pub_shi") 
//				+ _serverDate.minutes + Lang.getLabel("pub_fen");
			
			var _t1:String = "";
			var _t2:String = "";
			
			if((_nextMatchDate.hours) < 10)
			{
				_t1 = 0 +""+ (_nextMatchDate.hours);
			}
			else
			{
				_t1 = ""+ (_nextMatchDate.hours);
			}
			
			if((_nextMatchDate.minutes) < 10)
			{
				_t2 = 0 +""+ (_nextMatchDate.minutes);
			}
			else
			{
				_t2 = ""+ (_nextMatchDate.minutes);
			}
			
			mc['mcFighting']['tf_start_time'].text = _t1+":"+_t2;
			mc['mcLastMatch']['tf_start_time'].text = _t1+":"+_t2;
			
			
			
			//下一场开始还需要多少时间
			var _comingTime:Number = _nextMatchDate.time - _serverDate.time;
			if(_comingTime < 0 )
			{
				_comingTime = 0;
			}
			
			_repaintTime(_comingTime );
			
			return ;
			
			
		}
		
		
		
		private function _repaintTime(t:int=0):void
		{
			//			if (null != this.m_countDownTool)
			//			{
			//				this.m_countDownTool.stop();
			//			}
			
			var _t:int = t;
			
			if (null == this.m_countDownTool)
			{
				this.m_countDownTool=new CountDownTool(mc['mcFighting']['tf_remainderTime']);
			}
			if (!this.m_countDownTool.isRunning())
			{
				this.m_countDownTool.start(_t);
			}
			this.m_countDownTool.updata(_t);
		}
		
		
		
		
		
		
		
		
		
	}
	
	
	
}


