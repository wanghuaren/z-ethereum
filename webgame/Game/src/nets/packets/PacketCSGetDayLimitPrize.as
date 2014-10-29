package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得每日必做奖励
    */
    public class PacketCSGetDayLimitPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39903;
        /** 
        *领取step 1 2 3 4
        */
        public var step:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(step);
        }
        public function Deserialize(ar:ByteArray):void
        {
            step = ar.readInt();
        }
    }
}
