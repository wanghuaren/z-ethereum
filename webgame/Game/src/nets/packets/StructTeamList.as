package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *附近队伍列表
    */
    public class StructTeamList implements ISerializable
    {
        /** 
        *队伍ID
        */
        public var teamid:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(teamid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            teamid = ar.readInt();
        }
    }
}
