package ui.component
{
	import flash.events.Event;

	public class XHTreeEvent extends Event
	{
		public static const ITEM_CLOSE:String = "itemClose";
		public static const ITEM_OPEN:String = "itemOpen";
		public static const ITEM_OPENING:String = "itemOpening";
		
		public static const ITEM_CLICK:String = "itemClick";
		
		private var array:*;
		
		public static const XHTREE_EVENT:String = "XHTREE_EVENT";
		
		public function XHTreeEvent(type:String,datas:*=null) {
			super(type);
			array=datas;
		}
		
		public function get getInfo():* {
			return array;
		}
		
		public function set getInfo(datas:*):void {
			array=datas;
		}
		
		override public function clone():Event
		{
			return new XHTreeEvent(XHTreeEvent.XHTREE_EVENT);
		}
		
		
	}
}