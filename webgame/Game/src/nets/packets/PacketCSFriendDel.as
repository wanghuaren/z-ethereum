package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *删除好友
    */
    public class PacketCSFriendDel implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 3010;
        /** 
        *角色ID
        */
        public var roleid:int;
        /** 
        *类型，好友：1,黑名单：4
        */
        public var type:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleid);
            ar.writeInt(type);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            type = ar.readInt();
        }
    }
}
