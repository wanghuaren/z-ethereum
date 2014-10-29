package ui.view.gerenpaiwei
{
	/**
	 * 仙道至尊
	 * @author steven guo
	 * 
	 */	
	public class GRPW_P_2
	{
		private var m_ui:* = null;
		
		public function GRPW_P_2(ui:*)
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