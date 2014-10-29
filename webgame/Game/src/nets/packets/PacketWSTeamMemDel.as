package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *减少成员
    */
    public class PacketWSTeamMemDel implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 18009;
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
