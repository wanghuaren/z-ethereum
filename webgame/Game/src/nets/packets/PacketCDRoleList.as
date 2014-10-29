package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *角色列表
    */
    public class PacketCDRoleList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 108;
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
