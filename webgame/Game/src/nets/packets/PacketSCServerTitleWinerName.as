package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得服务器第一人返回
    */
    public class PacketSCServerTitleWinerName implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39901;
        /** 
        *要塞1
        */
        public var name_1:String = new String();
        /** 
        *要塞2
        */
        public var name_2:String = new String();
        /** 
        *要塞3
        */
        public var name_3:String = new String();
        /** 
        *pk之王名称
        */
        public var name_4:String = new String();
        /** 
        *皇城霸主名称
        */
        public var name_5:String = new String();
        /** 
        *皇城霸主工会名次
        */
        public var name_6:String = new String();
        /** 
        *皇城霸主天数
        */
        public var day_5:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            PacketFactory.Instance.WriteString(ar, name_1, 64);
            PacketFactory.Instance.WriteString(ar, name_2, 64);
            PacketFactory.Instance.WriteString(ar, name_3, 64);
            PacketFactory.Instance.WriteString(ar, name_4, 64);
            PacketFactory.Instance.WriteString(ar, name_5, 64);
            PacketFactory.Instance.WriteString(ar, name_6, 64);
            ar.writeInt(day_5);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var name_1Length:int = ar.readInt();
            name_1 = ar.readMultiByte(name_1Length,PacketFactory.Instance.GetCharSet());
            var name_2Length:int = ar.readInt();
            name_2 = ar.readMultiByte(name_2Length,PacketFactory.Instance.GetCharSet());
            var name_3Length:int = ar.readInt();
            name_3 = ar.readMultiByte(name_3Length,PacketFactory.Instance.GetCharSet());
            var name_4Length:int = ar.readInt();
            name_4 = ar.readMultiByte(name_4Length,PacketFactory.Instance.GetCharSet());
            var name_5Length:int = ar.readInt();
            name_5 = ar.readMultiByte(name_5Length,PacketFactory.Instance.GetCharSet());
            var name_6Length:int = ar.readInt();
            name_6 = ar.readMultiByte(name_6Length,PacketFactory.Instance.GetCharSet());
            day_5 = ar.readInt();
        }
    }
}
