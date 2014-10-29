package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取充值活动1奖励
    */
    public class PacketCSActGetPaymentPrize1 implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38115;
        /** 
        *表示第几阶段
        */
        public var state:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            state = ar.readInt();
        }
    }
}
