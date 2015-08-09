package ui.view.view4.weiduan
{
	import flash.display.DisplayObject;
	
	import common.config.GameIni;
	
	import ui.frame.UIWindow;
	import ui.frame.WindowName;
	import ui.view.view2.other.ControlButton;
	
	/**
	 * 微端下载的提示窗口
	 * @author steven guo
	 * 
	 */	
	public class WeiDuanDownload extends UIWindow
	{
		private static var m_instance:WeiDuanDownload;
		
		public function WeiDuanDownload()
		{
			super(getLink(WindowName.win_xia_duan));
		}
		
		
		public static function getInstance():WeiDuanDownload
		{
			if(null == m_instance)
			{
				m_instance = new WeiDuanDownload();
				
			}
			
			return m_instance;
		}
		
		override protected function init():void
		{
			super.init();
			
			
		}
		
		override public function mcHandler(target:Object):void 
		{
			super.mcHandler(target);
			
			var name:String = target.name;
			
			switch(name)
			{
				case "btn_i_want":
					GameIni.downloadWeiduan();
					//ControlButton.getInstance().setVisible("arrWeiDuan",false);
					winClose();
					break;
				default:
					break;
			}
			
			
		}
		
	}
}



