package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *添加好友
    */
    public class PacketCSFriendAddS implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 3004;
        /** 
        *角色
        */
        public var rolename:String = new String();
        /** 
        *类型，好友：1,黑名单：4
        */
        public var type:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            PacketFactory.Instance.WriteString(ar, rolename, 64);
            ar.writeInt(type);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var rolenameLength:int = ar.readInt();
            rolename = ar.readMultiByte(rolenameLength,PacketFactory.Instance.GetCharSet());
            type = ar.readInt();
        }
    }
}
