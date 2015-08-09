package ui.view.view4.pkmatch
{
	import common.config.PubData;
	import common.managers.Lang;
	import common.utils.clock.GameClock;
	
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import model.pkmatch.PKMatchEvent;
	import model.pkmatch.PKMatchModel;
	
	import nets.packets.PacketSCPkReadyStart;
	
	import ui.frame.ImageUtils;
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import world.FileManager;
	import world.WorldEvent;
	
	/**
	 * PK 赛 ，配对成功的倒计时
	 * @author steven guo
	 * 
	 */	
	public class PKMatchPeiDuiWindow extends UIWindow
	{
		private static var m_instance:PKMatchPeiDuiWindow = null; 
		
		private var m_model:PKMatchModel = null;
		
		private static const MAX_REMAINING_TIME:int = 5;
		
		//默认5秒关闭窗口
		private var m_remainingTime:int = MAX_REMAINING_TIME;
		
		//private var m_timer:Timer = null;
		
		public function PKMatchPeiDuiWindow()
		{
			//super(getLink(WindowName.win_PK_peidui_chenggong));
			
			m_model = PKMatchModel.getInstance();
			
			//m_timer = new Timer(1000,5);
			//m_timer.addEventListener(TimerEvent.TIMER,_onTimerListener);
			//m_timer.addEventListener(TimerEvent.TIMER_COMPLETE,_onTimerCompleteListener);
			
			
		}
		
		public static function getInstance():PKMatchPeiDuiWindow
		{
			if(null == m_instance)
			{
				m_instance = new PKMatchPeiDuiWindow();
			}
			
			return m_instance;
		}
		
		/**
		 * 面板开启的时候初始化面板数据内容 
		 * 
		 */		
		override protected function init():void
		{
			super.init();
			
			//m_model.addEventListener(PKMatchEvent.PK_MATCH_EVENT,_processEvent);
			this.sysAddEvent(PubData.AlertUI,"PK_PeiDui",_onPK_PeiDui);
			
			m_remainingTime = MAX_REMAINING_TIME;
			
			repaint(m_type);
		}
		
		private function _onPK_PeiDui(e:DispatchEvent):void
		{
			if(null != this.parent)
			{
				this.parent.addChild(this);
				
			}
			
			
		}
		
		override public function winClose():void
		{
			super.winClose();
			
			//m_model.removeEventListener(PKMatchEvent.PK_MATCH_EVENT,_processEvent);
			
			
			GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onTimerListener);
		}
		
		/**
		 * 出来PK模块的消息 
		 * @param e
		 * 
		 */		
//		private function _processEvent(e:PKMatchEvent):void
//		{
//			
//		}
		
		private var m_type:int = 1;
		public function setType(t:int):void
		{
			m_type = t;
		}
		
		/**
		 * 显示信息 
		 * @param type  1 等待区   2 配对成功
		 * 
		 */		
		public function repaint(type:int):void
		{
			var _data:PacketSCPkReadyStart = null;
			
			//等待区
			if(1 == type)
			{
				GameClock.instance.removeEventListener(WorldEvent.CLOCK_SECOND,_onTimerListener);
				
				(mc as MovieClip).gotoAndStop(2);
				
			}
			//匹配成功
			else if(2 == type)
			{
				GameClock.instance.addEventListener(WorldEvent.CLOCK_SECOND,_onTimerListener);
				
				(mc as MovieClip).gotoAndStop(1);
				
				_data = m_model.getMakePairData();
				
				if(null == _data)
				{
					return ;
				}
				
//				mc['uil'].source = FileManager.instance.getHeadIconXById(_data.oppicon);
				ImageUtils.replaceImage(mc,mc["uil"],FileManager.instance.getHeadIconXById(_data.oppicon));
				mc['tf_king_paiming'].text = _data.oppranklevel;
				mc['tf_RemainingTime'].text = m_remainingTime;
				mc['tf_king_level'].text = _data.opplevel;
				
				//太乙
				if(2 == _data.oppcamp)
				{
					mc['tf_king_name'].text = _data.oppname; //"["+Lang.getLabel("pub_tai_yi")+"]"+_data.oppname;
				}
				//通天
				else if(3 == _data.oppcamp)
				{
					mc['tf_king_name'].text = _data.oppname; //"["+Lang.getLabel("pub_tong_tian")+"]"+_data.oppname;
				}
			}
			
			
		}
		
		private function _onTimerListener(e:WorldEvent):void
		{
			--m_remainingTime;
			
			if(m_remainingTime >=0)
			{
				mc['tf_RemainingTime'].text = m_remainingTime;
			}
			else 
			{
				winClose();
			}
		}
		
	}
	
	
}


