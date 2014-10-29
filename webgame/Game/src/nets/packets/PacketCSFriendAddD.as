package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *添加好友
    */
    public class PacketCSFriendAddD implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 3007;
        /** 
        *角色ID
        */
        public var roleid:int;
        /** 
        *是否同意邀请
        */
        public var accept:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleid);
            ar.writeInt(accept);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            accept = ar.readInt();
        }
    }
}
