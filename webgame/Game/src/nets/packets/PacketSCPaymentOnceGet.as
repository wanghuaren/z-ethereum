package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *领取单笔充值奖励
    */
    public class PacketSCPaymentOnceGet implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31124;
        /** 
        *奖励编号(下标从0开始)
        */
        public var prize_id:int;
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(prize_id);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            prize_id = ar.readInt();
            tag = ar.readInt();
        }
    }
}
