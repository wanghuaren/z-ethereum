package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *奖励状态
    */
    public class StructPrizeStateData implements ISerializable
    {
        /** 
        *奖励序号
        */
        public var prize_id:int;
        /** 
        *状态，0，未领取； 1已经领取
        */
        public var state:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(prize_id);
            ar.writeInt(state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            prize_id = ar.readInt();
            state = ar.readInt();
        }
    }
}
