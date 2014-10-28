package engine.utils.compress {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;

	//import event.DispatchEvent;

	//public class Zip extends Sprite {
	public class Zip extends EventDispatcher {

		public function Zip() {
		}

		public function load(url : String) : void {
			if (!getHasOwn(getFileName(url))) {
				var zip : ZipDCoder = new ZipDCoder;
				url = url;
				zip.load(url);
				zip.addEventListener(ZipEvent.ZIP_INIT, loadComplete);
				zip.addEventListener(IOErrorEvent.IO_ERROR, ioError);
				
				//fux
				zip.addEventListener(ProgressEvent.PROGRESS,loadProgress);
				
			} else {
			
				this.dispatchEvent(new ZipEvent(ZipEvent.ZIP_COMPLETED, getFileName(url)));
			}
		}
		
		private function loadProgress(evt:ProgressEvent):void
		{
			this.dispatchEvent(evt);
		}

		private function loadComplete(evt : ZipEvent) : void {
			var zip : ZipDCoder = evt.currentTarget as ZipDCoder;
			zip.removeEventListener(ZipEvent.ZIP_INIT, loadComplete);
			zip.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			zip.removeEventListener(ProgressEvent.PROGRESS,loadProgress);
			
			if (ZipData.ZIPFILE == null) ZipData.ZIPFILE = {};
			ZipData.ZIPFILE[zip.name] = zip;
			//this.dispatchEvent(new DispatchEvent(DispatchEvent.EVENT_LOAD_COMPLETE, zip.name));
			this.dispatchEvent(new ZipEvent(ZipEvent.ZIP_COMPLETED, zip.name));
		}

		public function readFile(zipname : String,filename : String) : String {
			var redata : String = null;
			if (getHasOwn(zipname)) {
				var zip : ZipDCoder = ZipData.ZIPFILE[zipname];
				var file : Object = zip.getFileByName(filename);
				if (file != null) {
					redata = file.data.toString();
				} else {
					redata = null;
				}
			} else {
				redata = null;
			}
			return redata;
		}
		
		public function readFileByByte(zipname : String,filename : String) :ByteArray {
			var redata :ByteArray
			if (getHasOwn(zipname)) {
				var zip : ZipDCoder = ZipData.ZIPFILE[zipname];
				var file : Object = zip.getFileByName(filename);
				if (file != null) {
					redata = file.data;
				} else {
					redata = null;
				}
			} else {
				redata = null;
			}
			return redata;
		}

		public function getFileList(zip : ZipDCoder) : String {
			return zip.toString();
		}

		public function getHasOwn(zipname : String) : Boolean {
			//检查ZIP压缩包是否已经加载
			zipname = zipname;
			if (ZipData.ZIPFILE != null && ZipData.ZIPFILE.hasOwnProperty(zipname)) {
				var zip : ZipDCoder = ZipData.ZIPFILE[zipname];
				if (zip != null) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}

		private function getFileName(names : String) : String {
			var na : int = names.lastIndexOf("/");
			na = na == -1 ? 0 : na + 1;
			names = names.substr(na, names.length);
			return names.toLowerCase();
		}

		private function ioError(evt : IOErrorEvent) : void {
			//Debug.instance.traceMsg("Zip Loader IoError");
			this.dispatchEvent(new ZipEvent(ZipEvent.ZIP_ERROR, evt));
		}
	}
}