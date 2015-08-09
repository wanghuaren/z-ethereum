package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取单笔充值信息
    */
    public class PacketSCPaymentOncePay implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31122;
        /** 
        *单笔充值数额
        */
        public var pay:int;
        /** 
        *当前奖励状态 bit位:第n档奖励是否领取(下标从0开始)，0：未领取，1：已经领取
        */
        public var prize_state:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pay);
            ar.writeInt(prize_state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pay = ar.readInt();
            prize_state = ar.readInt();
        }
    }
}
