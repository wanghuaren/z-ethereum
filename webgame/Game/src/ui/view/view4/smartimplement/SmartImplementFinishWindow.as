package ui.view.view4.smartimplement
{
	import flash.display.DisplayObject;
	
	import model.fuben.FuBenModel;
	import model.pkmatch.PKMatchModel;
	
	import nets.packets.PacketSCCallBack;
	
	import common.utils.StringUtils;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	import common.managers.Lang;
	
	
	/**
	 * 四神器挑战结束窗口
	 * @author steven guo
	 * 
	 */	
	public class SmartImplementFinishWindow extends UIWindow
	{
		private static var m_instance:SmartImplementFinishWindow = null;
		
		private var m_model:FuBenModel = null;
		
		public function SmartImplementFinishWindow()
		{
//			super(getLink(WindowName.win_go_on));
			
			m_model = FuBenModel.getInstance();
		}
		
		/**
		 * 获得单例 
		 * @return 
		 * 
		 */		
		public static function getInstance():SmartImplementFinishWindow
		{
			if (null == m_instance)
			{
				m_instance= new SmartImplementFinishWindow();
			}
			
			return m_instance;
		}
		
		override public function winClose():void
		{
			super.winClose();
			
		}
		
		/**
		 * 面板开启的时候初始化面板数据内容 
		 * 
		 */		
		override protected function init():void
		{
			super.init();
			
			_repaint();
		}
		
		
		/**
		 * 处理鼠标的点击事件  
		 * @param target
		 * 
		 */		
		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			
			var name:String=target.name;
			
			var _currentIndex:int = m_model.getCurrentIndex() - 4;
			
			
			
			if(0 == name.indexOf("btnNext"))
			{
				//继续挑战  ，先退出，再挑战。
				m_model.requestPlayerLeaveInstance();
			}
			else if(0 == name.indexOf("btnExit"))
			{
				//直接退出
				m_model.requestPlayerLeaveInstance();
			}
		}
		
		
		private function _repaint():void
		{
			
			//var _callBackData:PacketSCCallBack = m_model.getCallbackData();
			
			//当前挑战到第几层
			var _currentLevel:int = m_model.getCurrentLevel();
			
			//最高挑战到第几层
			var _maxLevel:int =  m_model.getMaxLevel();
			
			//建议挑战到第几层
			var _toNextLevel:int = m_model.getToNextLevel();
			
			//当前四神器副本的索引
			var _currentIndex:int = FuBenModel.getInstance().getCurrentIndex();
			
			if(_currentIndex <5 || _currentIndex > 8)
			{
				return ;
			}
			
			_currentIndex = _currentIndex - 5;
			
			//恭喜你挑战到了第XX层
			mc['tf_0'].text = _currentLevel; 
				
			if(_maxLevel <= _currentLevel)
			{
				_maxLevel = _currentLevel;
			}
			
			//历史最高记录
			mc['tf_1'].text = _maxLevel;
			
			//历史最高记录奖励
			if(_maxLevel <= 0)
			{
				mc['tf_2'].htmlText = "";
			}
			else
			{
				mc['tf_2'].htmlText = StringUtils.smartImplementCountReward(_currentIndex,_maxLevel);
			}
			
			
			//建议挑战到第几层
			mc['tf_3'].text = _toNextLevel;
			
			//建议挑战到第几层 的奖励
			mc['tf_4'].htmlText = StringUtils.smartImplementCountReward(_currentIndex,_toNextLevel);
			
		}
		
		
		
		
		
	}
	
	
}






