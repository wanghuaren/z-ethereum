package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取开服充值奖励状态
    */
    public class PacketSCGetStartPaymentState implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31110;
        /** 
        *返回结果
        */
        public var tag:int;
        /** 
        *充值元宝
        */
        public var coin3:int;
        /** 
        *领取状态,用位表示，1,2,3,4
        */
        public var state:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(coin3);
            ar.writeInt(state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            coin3 = ar.readInt();
            state = ar.readInt();
        }
    }
}
