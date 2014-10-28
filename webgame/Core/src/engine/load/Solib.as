package engine.load {

	import engine.utils.compress.ZLIB;
	
	import flash.net.SharedObject;

	public class Solib {
		private var _name : String;
		private var _so : SharedObject;

		public function Solib(name : String = "shuiyue") {
			_name = name;
			_so = SharedObject.getLocal(name, "/");
		}

		public function getName() : String {
			return _name;
		}

		public function clear() : void {
			_so.clear();
		}

		public function get size() : int {
			return _so.size;
		}

		public function put(key : String,value : *) : void {
			var valueData : Object = ZLIB.compress(value);
			key = "key_" + key;
			if (_so.data.lib == undefined) {
				var obj : Object = {};
				obj[key] = valueData;
				_so.data.lib = obj;
			} else {
				_so.data.lib[key] = valueData;
			}
			_so.flush();
		}

		public function get(key : String) : Object {
			return contains(key) ? ZLIB.uncompress(_so.data.lib["key_" + key]) : null;
		}

		public function remove(key : String) : Boolean {
			if (contains(key)) {
				delete _so.data.lib["key_" + key];
				_so.flush();
				return true;
			} else {
				return false;
			}
		}

		public function contains(key : String) : Boolean {
			key = "key_" + key;
			return _so.data.lib != undefined && _so.data.lib[key] != undefined;
		}
	}
}