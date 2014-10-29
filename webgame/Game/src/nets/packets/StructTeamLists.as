package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *附近队伍列表
    */
    public class StructTeamLists implements ISerializable
    {
        /** 
        *队长
        */
        public var leader:int;
        /** 
        *队长
        */
        public var leadername:String = new String();
        /** 
        *队伍成员
        */
        public var members:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(leader);
            PacketFactory.Instance.WriteString(ar, leadername, 64);
            ar.writeInt(members);
        }
        public function Deserialize(ar:ByteArray):void
        {
            leader = ar.readInt();
            var leadernameLength:int = ar.readInt();
            leadername = ar.readMultiByte(leadernameLength,PacketFactory.Instance.GetCharSet());
            members = ar.readInt();
        }
    }
}
