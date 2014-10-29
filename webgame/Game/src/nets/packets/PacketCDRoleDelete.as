package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *删除角色
    */
    public class PacketCDRoleDelete implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 109;
        /** 
        *账号ID
        */
        public var accountID:int;
        /** 
        *角色ID
        */
        public var roleid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(accountID);
            ar.writeInt(roleid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            accountID = ar.readInt();
            roleid = ar.readInt();
        }
    }
}
