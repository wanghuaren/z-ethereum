package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得每日奖励元宝
    */
    public class PacketCSGetDayPrizeRmb implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24211;
        /** 
        *领取limitid
        */
        public var limitid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(limitid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            limitid = ar.readInt();
        }
    }
}
