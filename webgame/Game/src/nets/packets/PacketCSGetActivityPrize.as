package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *领取每日奖励
    */
    public class PacketCSGetActivityPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24201;
        /** 
        *阶段id，目前分为4 级 对应 1 2 3 4
        */
        public var step_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(step_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            step_id = ar.readInt();
        }
    }
}
