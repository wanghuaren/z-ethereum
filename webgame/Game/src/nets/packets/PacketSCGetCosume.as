package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取消费返利信息返回
    */
    public class PacketSCGetCosume implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38101;
        /** 
        *消费返利开始日期,格式20120101
        */
        public var begin_date:int;
        /** 
        *消费返利结束日期
        */
        public var end_date:int;
        /** 
        *累计消费
        */
        public var num:int;
        /** 
        *消费返利领取状态,按位
        */
        public var state:int;
        /** 
        *是否有可领的消费返利奖励
        */
        public var hasGift:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(begin_date);
            ar.writeInt(end_date);
            ar.writeInt(num);
            ar.writeInt(state);
            ar.writeInt(hasGift);
        }
        public function Deserialize(ar:ByteArray):void
        {
            begin_date = ar.readInt();
            end_date = ar.readInt();
            num = ar.readInt();
            state = ar.readInt();
            hasGift = ar.readInt();
        }
    }
}
