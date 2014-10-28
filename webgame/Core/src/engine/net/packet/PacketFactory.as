package engine.net.packet
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import engine.support.IPacket;

	public class PacketFactory
	{
		private static var _instance:PacketFactory;
		private static var _cacheByteArray:ByteArray;
		private var _packetMap:Dictionary;

		public function PacketFactory()
		{
			_packetMap=new Dictionary();
		}

		public static function get Instance():PacketFactory
		{
			if (null == _instance)
			{
				_instance=new PacketFactory();
				_cacheByteArray=new ByteArray();
			}

			return _instance;
		}

		public function CreatePacket(packetId:int):IPacket
		{
			if (null == _packetMap[packetId] || undefined == _packetMap[packetId])
			{
//				throw new Error("can not find packet:" + packetId.toString() + " you should rebuild net.packets files " + " Func:CreatePacket Class:PacketFactory");
				trace("缺少包ID:" + packetId.toString() + " you should rebuild net.packets files " + " Func:CreatePacket Class:PacketFactory");
				return null;
			}
			//return _packetMap[packetId];
			return new _packetMap[packetId].constructor;
		}

		public function RegisterPacketType(obj:IPacket):void
		{
			_packetMap[obj.GetId()]=obj;
		}

		public function GetCharSet():String
		{
			return "gb2312";
			//return "gbk";
		}

		public function WriteString(byteArr:ByteArray, strValue:String, nMaxLen:int):void
		{
			_cacheByteArray.position=0;
			_cacheByteArray.writeMultiByte(strValue, GetCharSet());

			if (_cacheByteArray.position > nMaxLen)
			{
				throw new Error("Error String:" + strValue + " Len:" + _cacheByteArray.position + " > Max Len:" + nMaxLen);
			}
			else
			{
				byteArr.writeInt(_cacheByteArray.position);
				if (0 != _cacheByteArray.position)
					byteArr.writeBytes(_cacheByteArray, 0, _cacheByteArray.position);
			}
		}

		public function Do(obj:IPacket):void
		{

		}

	}
}
