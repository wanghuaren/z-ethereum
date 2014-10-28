package engine.event {
	import flash.events.EventDispatcher;

	/**
	 * @author  wanghuaren
	 * @version 2011-2-11
	 */
	public class EventRecord {
		private var pType:String=null;
		private var pTarget:EventDispatcher=null;
		private var pFunc:Function=null;

		public function EventRecord(mType:String,mTarget:EventDispatcher,mFunc:Function) {
			pType=mType;			pTarget=mTarget;			pFunc=mFunc;
		}

		public function set type(value:String):void {
			pType=value;
		}

		public function get type():String {
			return pType;
		}

		public function set target(value:EventDispatcher):void {
			pTarget=value;
		}

		public function get target():EventDispatcher {
			return pTarget;
		}

		public function set func(value:Function):void {
			pFunc=value;
		}

		public function get func():Function {
			return pFunc;
		}
	}
}
