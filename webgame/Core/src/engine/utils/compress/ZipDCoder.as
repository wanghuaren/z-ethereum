package engine.utils.compress {
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	//ProgressEvent.PROGRESS :evt.bytesLoaded, evt.bytesTotal
	public class ZipDCoder extends EventDispatcher {
		private var _name : String;
		internal var _list : Array;
		internal var _entry : Dictionary;

		public function ZipDCoder(name : String = null) {
			_list = [];
			_entry = new Dictionary(true);
			if (name) {
				_name = name;
			}
		}

		public function load(request : String) : void {
			try {
				if (!_name) {
					_name = request;
				}
				var parser : ZipParser = new ZipParser();
				parser.addEventListener(ZipEvent.ZIP_PARSE_COMPLETED, parseCompleted);
				parser.writeZipFromFile(this, request);
			} catch (e : Error) {
			}
		}

		public function getFileByName(name : String) : ZipFile {
			name = name;
			if (_entry.hasOwnProperty(name)) {
				return _entry[name] ? _entry[name] : null;
			} else {
				return null;
			}
		}

		public function getFileAt(index : uint) : ZipFile {
			return _list.length > index ? _list[index] : null;
		}

		private function parseCompleted(evt : ZipEvent) : void {
			var parser : ZipParser = evt.currentTarget as ZipParser;
			parser.removeEventListener(ZipEvent.ZIP_PARSE_COMPLETED, parseCompleted);
			parser = null;
			if (_list.length == 0) {
				dispatchEvent(new ZipEvent(ZipEvent.ZIP_FAILED, "Error"));
			} else {
				dispatchEvent(new ZipEvent(ZipEvent.ZIP_INIT));
			}
		}

		public function get name() : String {
			return _name;
		}

		public function set name(name : String) : void {
			this._name = name;
		}

		public function get length() : uint {
			return _list.length;
		}

		public override function toString() : String {
			if (_list.length > 0) {
				var str : String = "=====[ZIP压缩包" + name + "]=====\r";
				for (var i : int = 0;i < length; i++) {
					str += "序号:" + i + " --> " + _list[i].toString();
				}
				str += "=============================";
				return str + "\r";
			} else {
				return "";
			}
		}
	}
}