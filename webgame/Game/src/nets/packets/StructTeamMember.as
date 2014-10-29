package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *队伍
    */
    public class StructTeamMember implements ISerializable
    {
        /** 
        *成员ID
        */
        public var roleid:int;
        /** 
        *是否在线
        */
        public var online:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(roleid);
            ar.writeInt(online);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            online = ar.readInt();
        }
    }
}
