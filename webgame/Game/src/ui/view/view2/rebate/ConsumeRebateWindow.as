package ui.view.view2.rebate
{
	import flash.display.DisplayObject;
	
	import model.rebate.ConsumeRebateModel;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import common.managers.Lang;
	
	public class ConsumeRebateWindow extends UIWindow
	{
		private static var m_instance:ConsumeRebateWindow = null;
		
		private var m_model:ConsumeRebateModel = null;
		
		private static const MAX_NUM:int = 8;//6;
		
		private var m_list:Vector.<ConsumeRebateRewardItem> = null;
		
		public function ConsumeRebateWindow()
		{
			super(getLink(WindowName.win_fan_li));
			
			m_model = ConsumeRebateModel.getInstance();
		}
		
		
		public static function getInstance():ConsumeRebateWindow
		{
			if (null == m_instance)
			{
				m_instance= new ConsumeRebateWindow();
			}
			
			return m_instance;
		}
		
		override protected function init():void
		{
			super.init();
			//repaint();
			
			m_model.addEventListener(ConsumeRebateEvent.CONSUME_REBATE_EVENT ,_processEvent);
			
			m_model.requestCSGetCosume();
		}
		
		private function _initCom():void
		{
			var _ConsumeRebateRewardItem:ConsumeRebateRewardItem = null;
			var _rwardConfigList:Array =  m_model.getRwardConfigList();
			if(null == m_list)
			{
				m_list = new Vector.<ConsumeRebateRewardItem>();
				
				for(var i:int = 0; i < MAX_NUM ; ++i )
				{
					_ConsumeRebateRewardItem = new ConsumeRebateRewardItem(mc['item_'+i],_rwardConfigList[i]);
					_ConsumeRebateRewardItem.setIndex(i);
					m_list.push(_ConsumeRebateRewardItem);
				}
			}
			
			for(var n:int = 0; n < m_list.length ; ++n )
			{
				m_list[n].update();
			}
		}
		
		override public function open(must:Boolean=false, type:Boolean=true):void
		{
			super.open(must,type);
			
			
		}
		
		public function repaint(type:int=-1):void
		{
			_repaintHuoDongDesc();
			_repaintHuoDongTime();
			_repaintRemainderTime();
			_repaintYBConsumeNumber();
			_repaintReward();
		}
		
		//活动描述
		private function _repaintHuoDongDesc():void
		{
			mc['tf_HuoDongDesc'].htmlText = Lang.getLabel("40074_Consume_Rebate_Desc");  
		}
		
		//活动开始结束时间
		private function _repaintHuoDongTime():void
		{
			mc['tf_HuoDongTime'].htmlText = m_model.startTime()+"<font color='#fff5d2'>到</font><br>"+m_model.endTime();
		}
		
		//活动剩余时间
		private function _repaintRemainderTime():void
		{
			mc['tf_RemainderTime'].htmlText = m_model.remainderTime();//Lang.getLabel("40074_Consume_Rebate_Remainder_Time",[m_model.remainderTime()]);
		}
		
		//累计消费元宝数量
		private function _repaintYBConsumeNumber():void
		{
			mc['tf_YBConsumeNumber'].htmlText = m_model.getYBConsumeNumber();
		}
		
		//奖励内容
		private function _repaintReward():void
		{
			_initCom();
		}
		
		private function _processEvent(e:ConsumeRebateEvent):void
		{
			var _sort:int = e.sort;
			
			switch(_sort)
			{
				case ConsumeRebateEvent.CONSUME_REBATE_EVENT_SORT:
					repaint();
					break;
				default:
					break;
			}
		}
		
		
		
	}
	
	
//	class ConsumeRebateRewardItem
//	{
//		
//		public function ConsumeRebateRewardItem()
//		{
//			
//		}
//		
//		public function update():void
//		{
//			
//		}
//	}
	
	
}



