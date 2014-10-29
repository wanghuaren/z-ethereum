package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *qq任务集市信息
    */
    public class StructQQTaskInfo implements ISerializable
    {
        /** 
        *编号
        */
        public var id:int;
        /** 
        *类型1
        */
        public var sort1:int;
        /** 
        *参数1
        */
        public var para1:int;
        /** 
        *奖励1
        */
        public var prize1:int;
        /** 
        *奖励说明1
        */
        public var prizedesc1:String = new String();
        /** 
        *类型2
        */
        public var sort2:int;
        /** 
        *参数2
        */
        public var para2:int;
        /** 
        *奖励2
        */
        public var prize2:int;
        /** 
        *奖励说明2
        */
        public var prizedesc2:String = new String();
        /** 
        *类型3
        */
        public var sort3:int;
        /** 
        *参数3
        */
        public var para3:int;
        /** 
        *奖励3
        */
        public var prize3:int;
        /** 
        *奖励说明3
        */
        public var prizedesc3:String = new String();
        /** 
        *类型4
        */
        public var sort4:int;
        /** 
        *参数4
        */
        public var para4:int;
        /** 
        *奖励4
        */
        public var prize4:int;
        /** 
        *奖励说明4
        */
        public var prizedesc4:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(id);
            ar.writeInt(sort1);
            ar.writeInt(para1);
            ar.writeInt(prize1);
            PacketFactory.Instance.WriteString(ar, prizedesc1, 255);
            ar.writeInt(sort2);
            ar.writeInt(para2);
            ar.writeInt(prize2);
            PacketFactory.Instance.WriteString(ar, prizedesc2, 255);
            ar.writeInt(sort3);
            ar.writeInt(para3);
            ar.writeInt(prize3);
            PacketFactory.Instance.WriteString(ar, prizedesc3, 255);
            ar.writeInt(sort4);
            ar.writeInt(para4);
            ar.writeInt(prize4);
            PacketFactory.Instance.WriteString(ar, prizedesc4, 255);
        }
        public function Deserialize(ar:ByteArray):void
        {
            id = ar.readInt();
            sort1 = ar.readInt();
            para1 = ar.readInt();
            prize1 = ar.readInt();
            var prizedesc1Length:int = ar.readInt();
            prizedesc1 = ar.readMultiByte(prizedesc1Length,PacketFactory.Instance.GetCharSet());
            sort2 = ar.readInt();
            para2 = ar.readInt();
            prize2 = ar.readInt();
            var prizedesc2Length:int = ar.readInt();
            prizedesc2 = ar.readMultiByte(prizedesc2Length,PacketFactory.Instance.GetCharSet());
            sort3 = ar.readInt();
            para3 = ar.readInt();
            prize3 = ar.readInt();
            var prizedesc3Length:int = ar.readInt();
            prizedesc3 = ar.readMultiByte(prizedesc3Length,PacketFactory.Instance.GetCharSet());
            sort4 = ar.readInt();
            para4 = ar.readInt();
            prize4 = ar.readInt();
            var prizedesc4Length:int = ar.readInt();
            prizedesc4 = ar.readMultiByte(prizedesc4Length,PacketFactory.Instance.GetCharSet());
        }
    }
}
