package engine.utils.compress {
	import flash.events.Event;
	public class ZipEvent extends Event {
		public static var ZIP_INIT:String = "zip_init";
		public static var ZIP_FAILED:String = "zip_failed";
		internal static var ZIP_PARSE_COMPLETED:String = "zip_parse_completed";
		internal static var ZIP_PARSE_ERROR:String = "zip_parse_error";
		public static var ZIP_COMPLETED:String="zip_completed";		public static var ZIP_ERROR:String="zip_error";
		private var _content: * ;
		
		public static const ZIP_EVENT:String = "ZIP_EVENT";
		public function ZipEvent(type:String, content:*= null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this._content = content;
		}
		public function get content():* {
			return _content;
		}
		
		
		override public function clone():Event
		{
			return new ZipEvent(ZipEvent.ZIP_EVENT);
		}
	}
}
