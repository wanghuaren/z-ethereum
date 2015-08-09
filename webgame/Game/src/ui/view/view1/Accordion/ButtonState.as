package ui.view.view1.Accordion {
	import flash.display.SimpleButton;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;

	/**
	 * @author shuiyue
	 */
	public final class ButtonState {
		private var _bitmap : Bitmap;
		private var _bitmapdata : BitmapData;

		public function ButtonState(btn : SimpleButton) : void {
			_bitmapdata = new BitmapData(btn.upState.width, btn.upState.height, true, 0);
			_bitmapdata.draw(btn.upState as IBitmapDrawable);
			_bitmap = new Bitmap(_bitmapdata);
		}

		public function get upState() : DisplayObject {
			return _bitmap as DisplayObject;
		}
	}
}
