package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *角色改名
    */
    public class PacketCDRoleRename implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 135;
        /** 
        *角色信息
        */
        public var rolename:String = new String();
        /** 
        *userid
        */
        public var userid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            PacketFactory.Instance.WriteString(ar, rolename, 128);
            ar.writeInt(userid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var rolenameLength:int = ar.readInt();
            rolename = ar.readMultiByte(rolenameLength,PacketFactory.Instance.GetCharSet());
            userid = ar.readInt();
        }
    }
}
