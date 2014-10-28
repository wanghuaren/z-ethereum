package engine.utils.compress {
	import flash.utils.ByteArray;
	public class ZipFile {
		internal var _name:String;
		internal var _data:ByteArray;
		internal var _version:uint;
		internal var _encrypted:Boolean = false;
		internal var _compressionMethod:int = -1;
		internal var _dostime:uint;
		internal var _crc32:uint;
		internal var _compressedSize:uint;
		internal var _size:uint;
		internal var _flag:uint;
		internal var _extra:ByteArray;
		internal var _comment:String;
		internal var _encoding:String = "";
		internal var _nameLength:uint;
		internal var _extraLength:uint;
		public function ZipFile(name:String = null) {
			if (name) {
				_name = name;
			}
			_data = new ByteArray();
		}
		public function get name():String {
			return _name;
		}
		public function set name(names:String):void {
			_name = names;
		}
		public function get version():uint {
			return _version;
		}
		public function get size():uint {
			return _size;
		}
		public function get compressionMethod():int {
			return _compressionMethod;
		}
		public function get crc32():uint {
			return _crc32;
		}
		public function get compressedSize():uint {
			return _compressedSize;
		}
		internal function get encrypted():Boolean {
			return _encrypted;
		}
		internal function get flag():uint {
			return _flag;
		}
		internal function get extra():ByteArray {
			return _extra?_extra:null;
		}
		internal function get comment():String {
			return _comment?_comment:null;
		}
		public function get data():ByteArray {
			return _data;
		}
		public function set data(ba:ByteArray):void {
			_data = ba;
		}
		public function get date():Date {
			var sec:int = (_dostime & 0x1f) << 1;
			var min:int = (_dostime >> 5) & 0x3f;
			var hour:int = (_dostime >> 11) & 0x1f;
			var day:int = (_dostime >> 16) & 0x1f;
			var month:int = ((_dostime >> 21) & 0x0f) - 1;
			var year:int = ((_dostime >> 25) & 0x7f) + 1980;
			return new Date(year,month,day,hour,min,sec);
		}
		public function set date(date:Date):void {
			this._dostime =
			(date.fullYear - 1980 & 0x7f) << 25
			| (date.month + 1) << 21
			| date.date << 16
			| date.hours << 11
			| date.minutes << 5
			| date.seconds >> 1;
		}
		public function toString():String {
			var str:String = "[ ";
			str += _name + " ]\r";
			return str;
		}
	}
}