package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *排行榜奖励
    */
    public class PacketSCRankAwardRequire implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 28013;
        /** 
        *排行榜
        */
        public var sort:int;
        /** 
        *奖励ID
        */
        public var allow:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(sort);
            ar.writeInt(allow);
        }
        public function Deserialize(ar:ByteArray):void
        {
            sort = ar.readInt();
            allow = ar.readInt();
        }
    }
}
