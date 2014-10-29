package ui.view.view4.yunying
{
	import flash.display.MovieClip;
	
	import netc.Data;
	import netc.packets2.*;
	
	import nets.packets.*;

	public class HuoDongZhengHe_3
	{
		/**
		 * 
		 */ 
		public static var mc:MovieClip;
		
		private static var _p:PacketSCGetStartPaymentState2;
		

		public static function get p():PacketSCGetStartPaymentState2
		{
			if(null == _p)
			{
				_p = new PacketSCGetStartPaymentState2();
			}
			
			return _p;
		}

		public static function set p(value:PacketSCGetStartPaymentState2):void
		{
			_p = value;
		}

	}
}