package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructActCharRecInfoList2
    import netc.packets2.StructActCharRecInfoList2
    import netc.packets2.StructActCharRecInfo2
    /** 
    *活动得分榜
    */
    public class StructActCharRank implements ISerializable
    {
        /** 
        *总榜
        */
        public var total:StructActCharRecInfoList2 = new StructActCharRecInfoList2();
        /** 
        *当前榜
        */
        public var cur:StructActCharRecInfoList2 = new StructActCharRecInfoList2();
        /** 
        *当前日期
        */
        public var curday:int;
        /** 
        *昨日冠军
        */
        public var prev_first:StructActCharRecInfo2 = new StructActCharRecInfo2();

        public function Serialize(ar:ByteArray):void
        {
            total.Serialize(ar);
            cur.Serialize(ar);
            ar.writeInt(curday);
            prev_first.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            total.Deserialize(ar);
            cur.Deserialize(ar);
            curday = ar.readInt();
            prev_first.Deserialize(ar);
        }
    }
}
