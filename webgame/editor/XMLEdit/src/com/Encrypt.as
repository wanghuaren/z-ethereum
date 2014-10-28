package com
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;

	import mx.messaging.channels.StreamingAMFChannel;

	import spark.components.TextArea;

	public class Encrypt extends Sprite
	{
		private static var _instance:Encrypt=null;

		private var key:Array=["a"]

		public static function get instance():Encrypt
		{
			if (_instance == null)
			{
				_instance=new Encrypt();
			}
			return _instance;
		}

		public function Encrypt()
		{
		}

		private var file:File=null;

		private var byteArray:ByteArray=null;

		public var encode:int=0;

		public var decode:int=0;

		private var txtArea:TextArea=null;
		public var isLine:Boolean=false;

		public function encodeFile(code:String):void
		{
			encode=int(code);
			file=new File();
			file.addEventListener(FileListEvent.SELECT_MULTIPLE, encodeFileSelect);
			file.browseForOpenMultiple("打开要加密的文件", [new FileFilter("选择要加密文件", "*.xml;*.txt")]);
		}

		public function encodeFileSelect(e:FileListEvent):void
		{
			if (file != null)
			{
				file.removeEventListener(FileListEvent.SELECT_MULTIPLE, encodeFileSelect);
			}
			var fileArray:Array=e.files;
			var ba:ByteArray=null;
			var fileStream:FileStream=null;
			var num:uint=0;
			var count:uint=1;
			for (var fileNum:int=0; fileNum < fileArray.length; fileNum++)
			{
				ba=new ByteArray();
				fileStream=new FileStream();
				num=0;
				count=1;
				file=fileArray[fileNum];

				fileStream.open(file, FileMode.READ);
				fileStream.position=0;
				fileStream.readBytes(ba);
				ba.compress();
				ba.position=0;
				byteArray=new ByteArray();
				num=ba.readUnsignedByte();
				for (var i:int=1; i < ba.length; i++)
				{
					if (num == ba.readUnsignedByte())
					{
						count++;
					}
					else
					{
						byteArray.writeByte(count ^ encode);
						byteArray.writeByte(num ^ encode);
						count=1;
						ba.position-=1;
						num=ba.readUnsignedByte();
					}
					if (i == ba.length - 1)
					{
						byteArray.writeByte(count ^ encode);
						byteArray.writeByte(num ^ encode);
					}
				}
				byteArray.position=0;
				var array:Array=file.nativePath.split(".");
				array.pop();
				var path:String=array.join(".") + ".amd";
				file=new File(path);
				fileStream=new FileStream();
				fileStream.open(file, FileMode.WRITE);
				fileStream.writeBytes(byteArray);
				fileStream.close();
			}
		}

		public function decodeFile(code:String, txt:TextArea):void
		{
			txtArea=txt;
			decode=int(code);
			file=new File();
			file.addEventListener(FileListEvent.SELECT_MULTIPLE, decodeFileSelect);
			file.browseForOpenMultiple("打开要解密的文件", [new FileFilter("选择要解密文件", "*.amd")]);
		}

		private function decodeFileSelect(e:FileListEvent):void
		{
			file.removeEventListener(FileListEvent.SELECT_MULTIPLE, decodeFileSelect);

			var fileArray:Array=e.files;
			var ba:ByteArray=new ByteArray();
			var fileStream:FileStream=new FileStream();
			var num:uint=0;
			var count:uint=0;
			for (var fileNum:int=0; fileNum < fileArray.length; fileNum++)
			{
				ba=new ByteArray();
				fileStream=new FileStream();
				num=0;
				count=1;
				file=fileArray[fileNum];

				fileStream.open(file, FileMode.READ);
				fileStream.readBytes(ba);
				ba.position=0;
				byteArray=new ByteArray();
				byteArray.position=0;

				while (ba.bytesAvailable)
				{
					count=ba.readUnsignedByte() ^ decode;
					num=ba.readUnsignedByte() ^ decode;
					while (count > 0)
					{
						byteArray.writeByte(num);
						count--;
					}
				}
				byteArray.uncompress();
				byteArray.position=0;
				txtArea.text=byteArray.readMultiByte(byteArray.bytesAvailable, "utf-8");
				var array:Array=file.nativePath.split(".");
				array.pop();
				var path:String=array.join(".") + ".txt";
				file=new File(path);
				fileStream=new FileStream();
				fileStream.open(file, FileMode.WRITE);
				fileStream.writeBytes(byteArray);
				fileStream.close();
			}
		}

	}
}
