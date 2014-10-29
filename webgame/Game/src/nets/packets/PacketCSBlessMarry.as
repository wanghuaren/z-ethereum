package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *结婚祝福
    */
    public class PacketCSBlessMarry implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54005;
        /** 
        *祝福内容信息
        */
        public var msg:String = new String();
        /** 
        *祝福类型 1 2 3
        */
        public var sort:int;
        /** 
        *名称1
        */
        public var name1:String = new String();
        /** 
        *名称2
        */
        public var name2:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            PacketFactory.Instance.WriteString(ar, msg, 256);
            ar.writeInt(sort);
            PacketFactory.Instance.WriteString(ar, name1, 64);
            PacketFactory.Instance.WriteString(ar, name2, 64);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
            sort = ar.readInt();
            var name1Length:int = ar.readInt();
            name1 = ar.readMultiByte(name1Length,PacketFactory.Instance.GetCharSet());
            var name2Length:int = ar.readInt();
            name2 = ar.readMultiByte(name2Length,PacketFactory.Instance.GetCharSet());
        }
    }
}
