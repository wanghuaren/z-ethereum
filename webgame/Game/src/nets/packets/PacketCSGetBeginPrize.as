package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得新手目标奖励
    */
    public class PacketCSGetBeginPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 42301;
        /** 
        *新手目标limit
        */
        public var limit_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(limit_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            limit_id = ar.readInt();
        }
    }
}
