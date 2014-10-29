package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *角色离开公会
    */
    public class PacketWSGuildDelMember implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39200;
        /** 
        *公会标示
        */
        public var guildid:int;
        /** 
        *玩家标示
        */
        public var playerid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(guildid);
            ar.writeInt(playerid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            guildid = ar.readInt();
            playerid = ar.readInt();
        }
    }
}
