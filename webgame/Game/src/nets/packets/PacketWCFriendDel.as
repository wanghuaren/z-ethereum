package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *删除好友
    */
    public class PacketWCFriendDel implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 3012;
        /** 
        *角色ID
        */
        public var roleid:int;
        /** 
        *类型，好友：1,黑名单：4
        */
        public var type:int;
        /** 
        *错误消息
        */
        public var tag:int;
        /** 
        *错误消息
        */
        public var msg:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleid);
            ar.writeInt(type);
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            type = ar.readInt();
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
