package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *删除好友
    */
    public class PacketWDFriendDel implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 3014;
        /** 
        *角色ID
        */
        public var roleid:int;
        /** 
        *角色ID
        */
        public var friendid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleid);
            ar.writeInt(friendid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            friendid = ar.readInt();
        }
    }
}
