package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *领取连续登陆奖励
    */
    public class PacketCSGetContinueLoginPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 42305;
        /** 
        *领取第几天奖励1~7
        */
        public var prize_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(prize_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            prize_id = ar.readInt();
        }
    }
}
