package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *恢复删除的角色
    */
    public class PacketCDRoleResume implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 111;
        /** 
        *账号ID
        */
        public var accountID:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(accountID);
        }
        public function Deserialize(ar:ByteArray):void
        {
            accountID = ar.readInt();
        }
    }
}
