package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *更新好友
    */
    public class PacketWDFriendUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 3015;
        /** 
        *角色ID
        */
        public var roleid:int;
        /** 
        *角色ID
        */
        public var friendid:int;
        /** 
        *类型，好友：1,黑名单：4
        */
        public var type:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleid);
            ar.writeInt(friendid);
            ar.writeInt(type);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            friendid = ar.readInt();
            type = ar.readInt();
        }
    }
}
