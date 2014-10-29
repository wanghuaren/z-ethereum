package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *添加好友
    */
    public class PacketWCFriendAddD implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 3006;
        /** 
        *角色ID
        */
        public var roleid:int;
        /** 
        *邀请者
        */
        public var name:String = new String();
        /** 
        *是否是询问消息1.是0.不是
        */
        public var query:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleid);
            PacketFactory.Instance.WriteString(ar, name, 64);
            ar.writeInt(query);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            query = ar.readInt();
        }
    }
}
