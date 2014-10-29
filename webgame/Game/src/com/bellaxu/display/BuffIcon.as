package com.bellaxu.display
{
	import com.bellaxu.res.ResTool;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * buff图标
	 * @author BellaXu
	 */
	public class BuffIcon extends Sprite
	{
		private var _data:Object =null;
		private var _bitmap:Bitmap = null;
		public var tipParam:Array;
		
		public function BuffIcon():void
		{
			_bitmap = new Bitmap();
//			_bitmap.width = 16;
//			_bitmap.height = 16;
			this.addChild(_bitmap);
		}
		
		public function dispose():void
		{
			_data = null;
			_bitmap.bitmapData = null;
			_bitmap.parent.removeChild(_bitmap);
			_bitmap = null;
			tipParam = null;
		}
		
		public function set icon(id:int):void
		{
//			if (141 == id) return;//vip图标
			ResTool.load("Icon/Buff_" + id.toString() + ".png", onLoadedIcon);
		}
		
		private function onLoadedIcon(url:String):void
		{
			_bitmap.bitmapData = ResTool.getBmd(url);
		}
		
		public function set data(objdata:Object):void
		{
			_data=objdata;
		}

		public function get data():Object
		{
			return _data;
		}
	}
}
