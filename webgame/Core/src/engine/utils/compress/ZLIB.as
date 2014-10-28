package engine.utils.compress{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	public class ZLIB extends EventDispatcher{
		private static var year:String = "20100625";
		public static function compress(data : Object):String {
			var str:String;
			var bty : ByteArray = new ByteArray();
			bty.writeObject(data);
			bty.compress();
			bty.position = 0;
			str = ByteCode.ByteArrayToString(bty);
			return str;
		}

		public static function uncompress(data : String):Object {
			var bty:ByteArray = ByteCode.StringToByteArray(data);
			bty.position = 0;
			bty.uncompress();
			bty.position = 0;
			return bty.readObject();
		}

		public static function ECode(char:String,key:String,zlib:Boolean=false):String {
			var Re:String = ResKeyCode.encrypt(char,key);
			if (zlib) {
				Re = compress(Re as Object);
			}
			return Re;
		}

		public static function DCode(char:String,key:String,zlib:Boolean=false):String {
			if (zlib) {
				return ResKeyCode.decrypt((uncompress(char) as String),key);
			} else {
				return ResKeyCode.decrypt(char,key);
			}
		}
	}
}