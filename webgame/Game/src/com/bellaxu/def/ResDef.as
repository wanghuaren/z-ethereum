package com.bellaxu.def
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * 资源宏
	 * @author BellaXu
	 */
	public final class ResDef
	{
		[Embed(source="defaultMovie.png")]
		private static var defaultIMG:Class;
		private static var _defaultMovie:BitmapData;
		
		public static function get defautlBody():BitmapData
		{
			if (_defaultMovie == null)
				_defaultMovie=((new defaultIMG()) as Bitmap).bitmapData;
			return _defaultMovie;
		}
	}
}
