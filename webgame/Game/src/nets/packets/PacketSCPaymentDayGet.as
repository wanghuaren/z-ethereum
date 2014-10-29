package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *领取今日充值奖励
    */
    public class PacketSCPaymentDayGet implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31104;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *当前奖励ID
        */
        public var curr_prize_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(curr_prize_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            curr_prize_id = ar.readInt();
        }
    }
}
