package ui.frame
{
	import common.config.xmlres.XmlManager;
	
	import engine.managers.ResourceBackLoadManager;
	
	import netc.Data;
	
	import world.FileManager;

	/**
	 * 窗口资源预加载
	 */
	public class WindowResourcePreLoader
	{
		private static var _instance:WindowResourcePreLoader = null;
		public function WindowResourcePreLoader()
		{
		}
		
		public static function getInstance():WindowResourcePreLoader{
			if (_instance == null){
				_instance = new WindowResourcePreLoader();
			}
			return _instance;
		}
		
		/**
		 * 窗口资源预加载启动检测
		 */
		public function checkResourcePreload():void{
			var userLv:int = Data.myKing.level;
			var loadResList:Array = XmlManager.localres.getInterfaceClewXml.getWindowResource(userLv);
			while (loadResList.length>0){
				var flaUrl:String = WindowName.getFlaName(loadResList.shift());
				var fullUrl:String = FileManager.instance.getUI(flaUrl);
				ResourceBackLoadManager.getInstance().loadResource(fullUrl);
			}
		}
	}
}