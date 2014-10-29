package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *联系GM
    */
    public class PacketCSGameGM implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 10086;
        /** 
        *问题类型
        */
        public var type:int;
        /** 
        *问题内容
        */
        public var content:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            PacketFactory.Instance.WriteString(ar, content, 512);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            var contentLength:int = ar.readInt();
            content = ar.readMultiByte(contentLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
