package com.engine.utils
{
	import flash.display.*;
	import flash.system.*;
	import flash.utils.*;
	/**
	 *　SWF文件连接名读取类 
	 * @author saiman
	 * 
	 */	
	public class SWF extends Object {
		public static var tagNum:int=0
		private var __swf:ByteArray=new ByteArray  ;
		private var __className:Array=[]
		public function SWF(_swf:ByteArray) {
			tagNum=0
			__swf.writeBytes(_swf);
			__swf.endian=Endian.LITTLE_ENDIAN;
			
		}
		/**
		 *获取资源库的链接标签类名 
		 * @return 
		 * 
		 */		
		public function getClassNames() :*{
			__swf.position=0;
			__swf.endian=Endian.LITTLE_ENDIAN;
			var compressFlag:*=__swf.readUTFBytes(3);
			if (compressFlag != "FWS" && compressFlag != "CWS") {
				throw new Error("错误的SWF文件格式");
			}
			__swf.readByte()
           	__swf.readUnsignedInt();
            __swf.readBytes(__swf);
			__swf.length=__swf.length - 8;
			if (compressFlag == "CWS") {
				__swf.uncompress();
			}
			__swf.position=13
			while (__swf.bytesAvailable) {
				readSWFTag(__swf);
			}
			__swf.position=0;
			__swf.endian=Endian.BIG_ENDIAN;
			return __className;
		}
		private function readSWFTag(param1:ByteArray):void {
			var tag:*=param1.readUnsignedShort();
			
			var tagFlag:*=tag >> 6;
			var tagLength:*=tag & 63;			
			if ((tagLength & 63 )== 63) {
				tagLength=param1.readUnsignedInt();
			}
			
			//trace(tag,tagFlag,tagLength)			
			if (tagFlag == 76) {
				var tagContent:ByteArray=new ByteArray  ;
				if (tagLength != 0) {
					param1.readBytes(tagContent,0,tagLength);
				}
				getClass(tag,tagFlag,tagLength,tagContent);
			} else {
				param1.position=param1.position + tagLength;
			}
			return;
		}
		private function getClass(param1:uint,param2:int,param3:int,param4:ByteArray):void {
			var _loc_7:int;
			var _loc_8:String;			
			var _loc_5:* =readUI16(param4);
			var _loc_6:int=0;			
			while (_loc_6 < _loc_5) {				
				_loc_7=readUI16(param4);				
				_loc_8=readSwfString(param4);			
				__className.push(_loc_8);
				_loc_6++;
				tagNum++
				if(tagNum>1000)
				{
					
					return 
				}
			}
			
			return;
		}
		private function readSwfString(param1:ByteArray):String {
			var _loc_2:ByteArray;
			var _loc_3:int=1;
			var _loc_4:int=0;
			var _loc_5:String;
			while (true) {
				_loc_4=param1.readByte();				
				if (_loc_4 == 0) {
					_loc_2=new ByteArray  ;
					_loc_2.writeBytes(param1,param1.position - _loc_3,_loc_3);
					_loc_2.position=0;
					_loc_5=_loc_2.readUTFBytes(_loc_3);
					break;
				}
				_loc_3++;
			}
			return _loc_5;
		}
		private function readUI16(param1:ByteArray):int {
			var _loc_2:* =param1.readUnsignedByte();
			var _loc_3:* =param1.readUnsignedByte();			
			return _loc_2 +(_loc_3 << 8);
		}
	}
}
/*
var loader:Loader=new Loader()
loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onOK)
loader.load(new URLRequest("元件.swf"))
function onOK(e){	
	
	var swf=new SWF(e.target.bytes)
	var classList=swf.getClassNames()
	
	for(var i=0;i<classList.length;i++){		
		var c=e.target.applicationDomain.getDefinition(classList[i].toString())		
		var mc=new c
		addChild(mc)
	}
	
} 
*/