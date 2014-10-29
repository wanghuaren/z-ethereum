package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家角色信息
    */
    public class StructGuildPlayerAllyInfoItem implements ISerializable
    {
        /** 
        *角色ID
        */
        public var userid:int;
        /** 
        *角色名称
        */
        public var username:String = new String();
        /** 
        *头像id
        */
        public var head:int;
        /** 
        *是否协助
        */
        public var flag:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(userid);
            PacketFactory.Instance.WriteString(ar, username, 32);
            ar.writeInt(head);
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            var usernameLength:int = ar.readInt();
            username = ar.readMultiByte(usernameLength,PacketFactory.Instance.GetCharSet());
            head = ar.readInt();
            flag = ar.readInt();
        }
    }
}
