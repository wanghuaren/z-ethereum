package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *踢出队伍或者离开队伍
    */
    public class PacketWCTeamMemDel implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 18017;
        /** 
        *队伍ID
        */
        public var teamid:int;
        /** 
        *角色ID
        */
        public var roleid:int;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *错误信息
        */
        public var msg:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(teamid);
            ar.writeInt(roleid);
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            teamid = ar.readInt();
            roleid = ar.readInt();
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
