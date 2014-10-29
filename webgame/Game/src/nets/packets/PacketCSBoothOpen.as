package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *出摊
    */
    public class PacketCSBoothOpen implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8600;
        /** 
        *摊位名称
        */
        public var name:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            PacketFactory.Instance.WriteString(ar, name, 20);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
