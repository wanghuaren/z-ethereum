package engine.utils.compress {
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	//import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import engine.utils.compress.ZipDCoder;
	import engine.utils.compress.ZipEvent;
	import engine.utils.compress.ZipFile;
	import engine.utils.compress.ZipInflater;
	import engine.utils.compress.ZipTag;

	internal class ZipParser extends EventDispatcher {
		private var data : ByteArray;
		private var zip : ZipDCoder;
		private namespace localfile;

//		public function ZipParser() {
//		}

		internal function writeZipFromFile(zip : ZipDCoder, filename : String) : void {
			if (!zip) return;
			this.zip = zip;
			data = new ByteArray();
			data.endian = Endian.LITTLE_ENDIAN;
			load(filename);
		}

		internal function writeZipFromStream(zip : ZipDCoder, data : ByteArray) : void {
			if (!zip) return;
			this.zip = zip;
			this.data = data;
			data.position = 0;
			parse();
		}

		private function load(filename : String) : void {
			var stream : URLStream = new URLStream();
			stream.load(new URLRequest(filename));
			stream.addEventListener(ProgressEvent.PROGRESS, fileloading);
			stream.addEventListener(Event.COMPLETE, fileLoaded);
			stream.addEventListener(IOErrorEvent.IO_ERROR, onError);
		}

		private function onError(evt : IOErrorEvent) : void {
			var stream : URLStream = evt.currentTarget as URLStream;
			stream.removeEventListener(ProgressEvent.PROGRESS, fileloading);
			stream.removeEventListener(Event.COMPLETE, fileLoaded);
			stream.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			zip.dispatchEvent(evt.clone());
		}

		private function fileloading(evt : ProgressEvent) : void {
			zip.dispatchEvent(evt.clone());
		}

		private function fileLoaded(evt : Event) : void {
			var stream : URLStream = evt.currentTarget as URLStream;
			stream.removeEventListener(ProgressEvent.PROGRESS, fileloading);
			stream.removeEventListener(Event.COMPLETE, fileLoaded);
			stream.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			stream.readBytes(data);
			stream.close();
			stream = null;
			parse();
		}

		private function parse() : void {
			try {
				while (parseFile()) { }
				dispatchEvent(new ZipEvent(ZipEvent.ZIP_PARSE_COMPLETED));
			}catch (e : Error) {
				zip.dispatchEvent(new ZipEvent(ZipEvent.ZIP_FAILED, e.message));
				//Debug.instance.traceMsg(e);
			}
			data = null;
		}

		private function parseFile() : Boolean {
			var tag : uint = data.readUnsignedInt();
			switch(tag) {
				case ZipTag.LOCSIG:
					var file : ZipFile = new ZipFile();
					localfile::parseHeader(file);
					if (file._nameLength || file._extraLength) localfile::parseExt(file);
					localfile::parseContent(file);
					zip._list.push(file);
					if (file.name) zip._entry[file.name] = file;
					return true;
				case ZipTag.ENDSIG:
					return true;
				case ZipTag.CENSIG:
					return true;
			}
			return false;
		}

		localfile function parseContent(file : ZipFile) : void {
			if (!file._compressedSize) return;
			var compressedData : ByteArray = new ByteArray();
			data.readBytes(compressedData, 0, file._compressedSize);
			switch(file._compressionMethod) {
				case ZipTag.STORED:
					file._data = compressedData;
					break;
				case ZipTag.DEFLATED:
					var ba : ByteArray = new ByteArray();
					var inflater : ZipInflater = new ZipInflater();
					inflater.setInput(compressedData);
					inflater.inflate(ba);
					file._data = ba;
					break;
				default:
					throw new Error("invalid compression method");
			}
		}

		localfile function parseExt(file : ZipFile) : void {
			if (file._encoding == "utf-8") {
				file.name = data.readUTFBytes(file._nameLength);
			} else {
				file.name = data.readMultiByte(file._nameLength, file._encoding);
			}
			var len : uint = file._extraLength;
			if (len > 4) {
				var id : uint = data.readUnsignedShort();
				var size : uint = data.readUnsignedShort();
				if (size > len) throw new Error("Parse Error: extra field data size too big");
				if (id === 0xdada && size === 4) {
				}else if (size > 0) {
					file._extra = new ByteArray();
					data.readBytes(file._extra, 0, size);
				}
				len -= size + 4;
			}
			if (len > 0) data.position += len;
		}

		localfile function parseHeader(file : ZipFile) : void {
			file._version = data.readUnsignedShort();
			file._flag = data.readUnsignedShort();
			file._compressionMethod = data.readUnsignedShort();
			file._encrypted = (file._flag & 0x01) !== 0;
			if ((file._flag & 800) !== 0) file._encoding = "utf-8";
			file._dostime = data.readUnsignedInt();
			file._crc32 = data.readUnsignedInt();
			file._compressedSize = data.readUnsignedInt();
			file._size = data.readUnsignedInt();
			file._nameLength = data.readUnsignedShort();
			file._extraLength = data.readUnsignedShort();
		}
	}
}
