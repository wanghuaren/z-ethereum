package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *家族动态
    */
    public class PacketCSGuildLog implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39236;
        /** 
        *家族
        */
        public var guildid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(guildid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            guildid = ar.readInt();
        }
    }
}
