package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructActCharRecInfoList2
    import netc.packets2.StructActCharRecInfo2
    /** 
    *领取消费返利奖励返回
    */
    public class PacketSCGetChineseNewYearRank implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38107;
        /** 
        *榜内容
        */
        public var cur:StructActCharRecInfoList2 = new StructActCharRecInfoList2();
        /** 
        *冠军
        */
        public var prev_first:StructActCharRecInfo2 = new StructActCharRecInfo2();
        /** 
        *自己第几名
        */
        public var index:int;
        /** 
        *0表示日排行榜,1表示总榜
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            cur.Serialize(ar);
            prev_first.Serialize(ar);
            ar.writeInt(index);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            cur.Deserialize(ar);
            prev_first.Deserialize(ar);
            index = ar.readInt();
            tag = ar.readInt();
        }
    }
}
