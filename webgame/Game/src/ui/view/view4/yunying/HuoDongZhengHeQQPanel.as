package ui.view.view4.yunying
{
	import netc.DataKey;
	
	import nets.packets.PacketCSQQInstallSuccess;

	public class HuoDongZhengHeQQPanel
	{
		
		private static var _instance:HuoDongZhengHeQQPanel;
		
		public static function get instance():HuoDongZhengHeQQPanel
		{
			if(null == _instance)
			{
				_instance = new HuoDongZhengHeQQPanel();
			}
			
			return _instance;
		
		}
		
		public function addQQPanelOK():void
		{
			var cs:PacketCSQQInstallSuccess = new PacketCSQQInstallSuccess();
			
			DataKey.instance.send(cs);
			
			var isOpened:Boolean = HuoDongZhengHe.getInstance().isOpen;
			if(isOpened){
			HuoDongZhengHe.getInstance().refresh();
			}
		}
		
		
	}
}