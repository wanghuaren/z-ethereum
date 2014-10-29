package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *修改帮派名称
    */
    public class PacketCSGuildRename implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39264;
        /** 
        *新帮派名字
        */
        public var name:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            PacketFactory.Instance.WriteString(ar, name, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
