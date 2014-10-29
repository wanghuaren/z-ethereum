package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *公会升级
    */
    public class PacketCSGuildLevelUp implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39216;
        /** 
        *公会
        */
        public var guildid:int;
        /** 
        *0升级1降级
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(guildid);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            guildid = ar.readInt();
            tag = ar.readInt();
        }
    }
}
