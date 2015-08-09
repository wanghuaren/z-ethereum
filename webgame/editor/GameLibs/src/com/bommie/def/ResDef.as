package com.bommie.def
{
	import flash.display.Bitmap;
	
	import starling.textures.Texture;

	public final class ResDef
	{
		[Embed(source="defaultMovie.png")]
		private static var defaultIMG:Class;
		private static var _defaultMovie:Texture;
		
		public static function get defautlBody():Texture
		{
			if (_defaultMovie == null)
				_defaultMovie=Texture.fromBitmap((new defaultIMG()) as Bitmap);
			return _defaultMovie;
		}
	}
}
