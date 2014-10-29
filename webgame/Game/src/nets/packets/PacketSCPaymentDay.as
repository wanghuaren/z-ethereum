package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取今日充值信息
    */
    public class PacketSCPaymentDay implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31102;
        /** 
        *今日充值
        */
        public var pay:int;
        /** 
        *当前奖励ID
        */
        public var curr_prize_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pay);
            ar.writeInt(curr_prize_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pay = ar.readInt();
            curr_prize_id = ar.readInt();
        }
    }
}
