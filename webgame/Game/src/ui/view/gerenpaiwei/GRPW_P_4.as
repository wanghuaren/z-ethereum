package ui.view.gerenpaiwei
{
	/**
	 * 帮派争霸
	 * @author steven guo
	 * 
	 */	
	public class GRPW_P_4
	{
		private var m_ui:* = null;
		
		public function GRPW_P_4(ui:*)
		{
			m_ui = ui;
		}
		
		public function mcHandler(target:Object):void
		{
			
			
			
		}
		
		public function set visible(b:Boolean):void
		{
			m_ui.visible = b;
			
			if(b)
			{
				_init();
			}
		}
		
		private function _init():void
		{
			
		}
		
		
	}
}