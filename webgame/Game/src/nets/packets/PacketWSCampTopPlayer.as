package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *阵营第一
    */
    public class PacketWSCampTopPlayer implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 28015;
        /** 
        *太乙
        */
        public var name2:String = new String();
        /** 
        *通天
        */
        public var name3:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            PacketFactory.Instance.WriteString(ar, name2, 64);
            PacketFactory.Instance.WriteString(ar, name3, 64);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var name2Length:int = ar.readInt();
            name2 = ar.readMultiByte(name2Length,PacketFactory.Instance.GetCharSet());
            var name3Length:int = ar.readInt();
            name3 = ar.readMultiByte(name3Length,PacketFactory.Instance.GetCharSet());
        }
    }
}
