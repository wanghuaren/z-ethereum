package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *踢出队伍或者离开队伍
    */
    public class PacketCSTeamMemDel implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 18011;
        /** 
        *队伍ID
        */
        public var teamid:int;
        /** 
        *角色ID
        */
        public var roleid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(teamid);
            ar.writeInt(roleid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            teamid = ar.readInt();
            roleid = ar.readInt();
        }
    }
}
