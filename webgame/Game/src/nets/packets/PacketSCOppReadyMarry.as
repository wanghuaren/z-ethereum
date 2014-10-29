package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *对方请求结婚
    */
    public class PacketSCOppReadyMarry implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54002;
        /** 
        *结果
        */
        public var tag:int;
        /** 
        *对方名称
        */
        public var name:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, name, 64);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
