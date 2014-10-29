package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *排行榜奖励
    */
    public class PacketCSRankAwardRequire implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 28012;
        /** 
        *排行榜1.战力3.等级5.星魂6.成就
        */
        public var sort:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(sort);
        }
        public function Deserialize(ar:ByteArray):void
        {
            sort = ar.readInt();
        }
    }
}
