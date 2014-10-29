package model.hefu
{
	

	/**
	 *@author WangHuaren
	 *2014-3-5_上午11:07:39
	 **/
	public class HeFuHuongDongPanelVO
	{
		private static var _instance:HeFuHuongDongPanelVO=null;

		public static function get instance():HeFuHuongDongPanelVO
		{
			if (_instance == null)
			{
				_instance=new HeFuHuongDongPanelVO();
			}
			return _instance;
		}
		/**
		 * 物品索引
		 * */
		public var index:int;
		/**
		 * 物品ID
		 * */
		public var id:int;
		/**
		 * ICON路径
		 * */
		public var icon:String;
		/**
		 * 物品名称
		 * */
		public var resName:String;
		/**
		 * 物品价格
		 * */
		public var price:String;
		/**
		 * 物品现在价格
		 * */
		public var nowPrice:String;
		/**
		 * 物品品级
		 * */
		public var level:int;
		/**
		 * 物品数量
		 * */
		public var num:int;
		/**
		 * 需要充元宝数
		 * */
		public var yuanBao:int;
	}
}
