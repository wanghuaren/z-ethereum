package engine.event
{
	import flash.events.Event;

	public final class DispatchEvent extends Event
	{
		private var array:*;

		public static const DISPATCH_EVENT:String="DISPATCH_EVENT";

		public static const EVENT_LOAD_COMPLETE:String="loadComplete";

		public static const EVENT_LOAD_PROGRESS:String="loadProgress";

		public static const EVENT_RES_PROGRESS:String="resComplete";

		public static const EVENT_LIST_CLICK:String="LIST_CLICK";

		public static const EVENT_IO_ERROR:String="IOErrorEvent";

		public static const EVENT_XML_SECURITY_ERROR:String="XMLSecurityError";

		public static const EVENT_SECURITY_ERROR:String="SecurityError";

		public static const EVENT_LOAD_IO_ERROR:String="loadIOERROR";

		public static const EVENT_XML_LOAD_PER:String="XMLLoadPer";

		public static const EVENT_COMB_CLICK:String="COMB_CLICK";

		public static const EVENT_SCROLL_EVENT:String="SCROLL_EVENT";

		public static const EVENT_CHAT_TEXT_LINK:String="chatTextlinkEvent";

		public static const EVENT_DOWN_HANDER:String="downHander";

		private static var _instance:DispatchEvent;

		public static function get instance():DispatchEvent
		{
			if (_instance == null)
			{
				_instance=new DispatchEvent("");
			}
			return _instance;
		}

//		private var dicEventItem:Dictionary=new Dictionary();

//		public function getPoolItem(type:String, datas:*=null):DispatchEvent
//		{
//			if (dicEventItem[type] == undefined)
//			{
//				dicEventItem[type]=new DispatchEvent(type, null);
//			}
//			dicEventItem[type].getInfo=datas;
//			return dicEventItem[type];
//		}

		public function DispatchEvent(type:String, datas:*=null)
		{
			super(type);
			array=datas;
		}

		public function get getInfo():*
		{
			return array;
		}

		public function set getInfo(datas:*):void
		{
			array=datas;
		}

		override public function clone():Event
		{
			return new DispatchEvent(type, array);
		}
	}
}
