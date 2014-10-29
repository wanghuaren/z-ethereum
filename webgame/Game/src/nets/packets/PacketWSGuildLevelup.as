package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *公会升级
    */
    public class PacketWSGuildLevelup implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39202;
        /** 
        *公会标示
        */
        public var guildid:int;
        /** 
        *新等级
        */
        public var newlevel:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(guildid);
            ar.writeInt(newlevel);
        }
        public function Deserialize(ar:ByteArray):void
        {
            guildid = ar.readInt();
            newlevel = ar.readInt();
        }
    }
}
