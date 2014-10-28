package engine.utils.compress {
	//import flash.utils.IDataOutput;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	internal class ZipSerializer {
		private namespace header;
		private namespace zipfile;
		private namespace zipend;
		private var stream : ByteArray;

		public function ZipSerializer() {
		}

		public function serialize(zip : ZipDCoder, method : uint = 8) : ByteArray {
			if (!zip.length) {
				return null;
			}
			stream = new ByteArray();
			var centralData : ByteArray = new ByteArray();
			stream.endian = centralData.endian = Endian.LITTLE_ENDIAN;
			var offset : uint;
			for (var i : uint = 0, filenum : uint = zip.length;i < filenum; i++) {
				var file : ZipFile = zip.getFileAt(i);
				var data : ByteArray = zipfile::serialize(file, method);
				header::serialize(stream, file, true);
				stream.writeBytes(data);
				header::serialize(centralData, file, false, offset);
				offset = stream.position;
			}
			stream.writeBytes(centralData);
			zipend::serialize(offset, stream.length - offset, filenum);
			return stream;
		}

		header function serialize(stream : ByteArray, file : ZipFile, local : Boolean = true, offset : uint = 0) : void {
			if (local) {
				stream.writeUnsignedInt(ZipTag.LOCSIG);
			} else {
				stream.writeUnsignedInt(ZipTag.CENSIG);
				stream.writeShort(file._version);
			}
			stream.writeShort(file._version);
			stream.writeShort(file._flag);
			stream.writeShort(file._compressionMethod);
			stream.writeUnsignedInt(file._dostime);
			stream.writeUnsignedInt(file._crc32);
			stream.writeUnsignedInt(file._compressedSize);
			stream.writeUnsignedInt(file._size);
			var ba : ByteArray = new ByteArray();
			if (file._encoding == "utf-8") {
				ba.writeUTFBytes(file._name);
			} else {
				ba.writeMultiByte(file._name, file._encoding);
			}
			file._nameLength = ba.position;
			stream.writeShort(file._nameLength);
			stream.writeShort(file._extra ? file._extra.length : 0);
			if (!local) {
				stream.writeShort(file._comment ? file._comment.length : 0);
				stream.writeShort(0);
				stream.writeShort(0);
				stream.writeUnsignedInt(0);
				stream.writeUnsignedInt(offset);
			}
			stream.writeBytes(ba);
			if (file._extra) {
				stream.writeBytes(file._extra);
			}
			if (!local && file._comment) {
				stream.writeUTFBytes(file._comment);
			}
		}

		zipfile function serialize(file : ZipFile, compressionMethod : uint = 8) : ByteArray {
			file._compressionMethod = compressionMethod;
			file._flag = 0;
			var data : ByteArray = new ByteArray();
			data.writeBytes(file.data);
			if (compressionMethod == ZipTag.DEFLATED) {
				try {
					data.compress();
				} catch (e : Error) {
				}
				file._compressedSize = data.length - 6;
				var tmpdata : ByteArray = new ByteArray();
				tmpdata.writeBytes(data, 2, data.length - 6);
				return tmpdata;
			} else if (compressionMethod == ZipTag.STORED) {
				file._compressedSize = data.length;
			}
			return data;
		}

		zipend function serialize(offset : uint, length : uint, filenum : uint) : void {
			stream.writeUnsignedInt(ZipTag.ENDSIG);
			stream.writeShort(0);
			stream.writeShort(0);
			stream.writeShort(filenum);
			stream.writeShort(filenum);
			stream.writeUnsignedInt(length);
			stream.writeUnsignedInt(offset);
			stream.writeShort(0);
		}
	}
}