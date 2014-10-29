package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *发送到邀请目标的
    */
    public class PacketSCTeamInvitDest implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 18002;
        /** 
        *邀请玩家ID
        */
        public var roleid:int;
        /** 
        *邀请玩家名字
        */
        public var rolename:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleid);
            PacketFactory.Instance.WriteString(ar, rolename, 32);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            var rolenameLength:int = ar.readInt();
            rolename = ar.readMultiByte(rolenameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
