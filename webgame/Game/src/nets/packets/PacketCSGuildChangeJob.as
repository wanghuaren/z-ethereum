package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *改变职位
    */
    public class PacketCSGuildChangeJob implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39245;
        /** 
        *玩家
        */
        public var playerid:int;
        /** 
        *新职位2:成员3:副会长4:会长
        */
        public var job:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(playerid);
            ar.writeInt(job);
        }
        public function Deserialize(ar:ByteArray):void
        {
            playerid = ar.readInt();
            job = ar.readInt();
        }
    }
}
