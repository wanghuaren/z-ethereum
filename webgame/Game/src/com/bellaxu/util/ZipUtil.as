package com.bellaxu.util
{
	import com.bellaxu.debug.Debug;
	
	import flash.utils.ByteArray;

	/**
	 * Zip工具
	 */
	public class ZipUtil
	{
		public static  function parse(data:ByteArray) : Vector.<ZipFile> 
		{
			var vec:Vector.<ZipFile> = new <ZipFile>[];
			try 
			{
				while (parseFile(data, vec)) {}
			}
			catch (e:Error) 
			{
				Debug.error("解压zip出现错误");
			}
			return vec
		}
		
		public static function parseFile(data:ByteArray, vec:Vector.<ZipFile>) : Boolean 
		{
			var tag : uint = data.readUnsignedInt();
			switch(tag) 
			{
				case ZipTag.LOCSIG:
					var file:ZipFile = new ZipFile();
					parseHeader(file, data);
					if (file._nameLength || file._extraLength) 
						parseExt(file, data);
					parseContent(file, data);
					vec.push(file);
					return true;
				case ZipTag.ENDSIG:
					return true;
				case ZipTag.CENSIG:
					return true;
			}
			return false;
		}
		
		public static function parseHeader(file:ZipFile, data:ByteArray) : void 
		{
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
		
		public static function parseExt(file:ZipFile, data:ByteArray) : void 
		{
			if (file._encoding == "utf-8") 
			{
				file.name = data.readUTFBytes(file._nameLength);
			} else 
			{
				file.name = data.readMultiByte(file._nameLength, file._encoding);
			}
			var len : uint = file._extraLength;
			if (len > 4) 
			{
				var id : uint = data.readUnsignedShort();
				var size : uint = data.readUnsignedShort();
				if (size > len) throw new Error("Parse Error: extra field data size too big");
				if (id === 0xdada && size === 4) 
				{
					
				}
				else if (size > 0) 
				{
					file._extra = new ByteArray();
					data.readBytes(file._extra, 0, size);
				}
				len -= size + 4;
			}
			if (len > 0) 
				data.position += len;
		}
		
		public static function parseContent(file:ZipFile, data:ByteArray) : void 
		{
			if (!file._compressedSize) 
				return;
			var compressedData:ByteArray = new ByteArray();
			data.readBytes(compressedData, 0, file._compressedSize);
			switch(file._compressionMethod) 
			{
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
	}
}