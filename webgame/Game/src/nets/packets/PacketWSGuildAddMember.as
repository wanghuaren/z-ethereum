package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *角色加入公会
    */
    public class PacketWSGuildAddMember implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39201;
        /** 
        *公会标示
        */
        public var guildid:int;
        /** 
        *公会名称
        */
        public var guildname:String = new String();
        /** 
        *job
        */
        public var job:int;
        /** 
        *玩家标示
        */
        public var playerid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(guildid);
            PacketFactory.Instance.WriteString(ar, guildname, 32);
            ar.writeInt(job);
            ar.writeInt(playerid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            guildid = ar.readInt();
            var guildnameLength:int = ar.readInt();
            guildname = ar.readMultiByte(guildnameLength,PacketFactory.Instance.GetCharSet());
            job = ar.readInt();
            playerid = ar.readInt();
        }
    }
}
