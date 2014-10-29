package ui.view.baifu
{

	/**
	 *@author WangHuaren
	 *2014-3-31_下午1:47:22
	 **/
	public class WinBaifuItem
	{
		public function WinBaifuItem()
		{
		}
		private static var _instance:WinBaifuItem=null;

		public static function get instance():WinBaifuItem
		{
			if (_instance == null)
			{
				_instance=new WinBaifuItem();
			}
			return _instance;
		}

		override protected function init():void
		{
			super.init();
		}

		override public function mcHandler(target:Object):void
		{
			super.mcHandler(target);
			switch (target.name)
			{
				case "":
					break;
			}
		}

		public function winClose():void
		{
			super.winClose();
		}
	}
}
