package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *队友详细信息
    */
    public class PacketWSTeamMemberDesc implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 18024;
        /** 
        *队友ID
        */
        public var roleid:int;
        /** 
        *请求者账号
        */
        public var accountid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleid);
            ar.writeInt(accountid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            accountid = ar.readInt();
        }
    }
}
