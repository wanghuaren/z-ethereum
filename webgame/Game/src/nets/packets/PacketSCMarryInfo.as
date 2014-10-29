package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *结婚信息数据返回
    */
    public class PacketSCMarryInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54014;
        /** 
        *免费礼包领取索引
        */
        public var index:int;
        /** 
        *名字1
        */
        public var name1:String = new String();
        /** 
        *名字2
        */
        public var name2:String = new String();
        /** 
        *结婚日期
        */
        public var marryday:int;
        /** 
        *结婚总日期
        */
        public var totalday:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(index);
            PacketFactory.Instance.WriteString(ar, name1, 32);
            PacketFactory.Instance.WriteString(ar, name2, 32);
            ar.writeInt(marryday);
            ar.writeInt(totalday);
        }
        public function Deserialize(ar:ByteArray):void
        {
            index = ar.readInt();
            var name1Length:int = ar.readInt();
            name1 = ar.readMultiByte(name1Length,PacketFactory.Instance.GetCharSet());
            var name2Length:int = ar.readInt();
            name2 = ar.readMultiByte(name2Length,PacketFactory.Instance.GetCharSet());
            marryday = ar.readInt();
            totalday = ar.readInt();
        }
    }
}
