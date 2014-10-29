package ui.view.view4.pkmatch
{
	import engine.event.DispatchEvent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	import netc.Data;
	import netc.dataset.MyCharacterSet;
	import netc.packets2.PacketSCPetData2;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	
	/**
	 * PK 赛参赛人员实时信息
	 * @author steven guo
	 * 
	 */	
	public class PKMatchPlayerInfo extends UIWindow
	{
		private static var m_instance:PKMatchPlayerInfo = null;
		
		public function PKMatchPlayerInfo()
		{
			//super(getLink(WindowName.win_PK_player_info));
		}
		
		/**
		 * 获得单例 
		 * @return 
		 * 
		 */		
		public static function getInstance():PKMatchPlayerInfo
		{
			if (null == m_instance)
			{
				m_instance= new PKMatchPlayerInfo();
			}
			
			return m_instance;
		}
		
		public static function getInstanceMc():DisplayObject
		{
		
			return m_instance.mc;
			
		}
		
		
		/**
		 * 面板开启的时候初始化面板数据内容 
		 * 
		 */		
		override protected function init():void
		{
			super.init();
									
			if(null != stage)
			{
				stage.addEventListener(Event.RESIZE, _resizeHandler);
			}
					
			replace();
		}
		
		
		override public function winClose():void
		{
			super.winClose();
			
			if(null != stage)
			{
				stage.removeEventListener(Event.RESIZE, _resizeHandler);
			}
			
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
				m_gPoint.x = ( (mc.stage.stageWidth - mc.width ) >> 1 ) - 15;
				m_gPoint.y = 30; //( (mc.stage.stageHeight - mc.height)>> 1 ) - 180;
				
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


