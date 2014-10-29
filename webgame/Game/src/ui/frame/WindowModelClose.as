package ui.frame
{
	import common.utils.bit.BitUtil;

	/**
	* 2013-03-11 andy
	* 运行商 关闭功能
	* 需要和服务端协商 1个int通过位来存储
	* 调用 WindowModelClose.isOpen(WindowModelClose.win_booth)
	*/
	public final class WindowModelClose
	{
		public static var data:int=0;
		/**
		 *	摆摊
		 */
		public static const win_booth:int=1;
		/**
		 *	充值
		 *  2013-08-22
		 */
		public static const IS_PAY:int=2;
		public static const win_shou_chong:int=3;
		public static const icon_goldTick:int=4;
		/**
		 *	交易
		 */
		public static const IS_DEAL:int=5;
		/**
		 *	交易
		 */
		public static const IS_Raffle:int=6;
		/**
		 *	运营商广告推送
		 */
		public static const IS_POPUPAD:int=7;
		/**
		 *	6.30/7.1 金券大放送
		 */
		public static const IS_GOLD_FREE:int=8;

		public function WindowModelClose()
		{
		}

		/**
		 *	 是否打开 1.true 可以使用 2.false 不可以使用
		 */
		public static function isOpen(num:int):Boolean
		{
			return BitUtil.getBitByPos(data, num) == 1;
		}
	}
}
