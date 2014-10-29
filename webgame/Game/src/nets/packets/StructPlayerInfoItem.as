package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家角色信息
    */
    public class StructPlayerInfoItem implements ISerializable
    {
        /** 
        *角色ID
        */
        public var userid:int;
        /** 
        *角色名称
        */
        public var username:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(userid);
            PacketFactory.Instance.WriteString(ar, username, 32);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            var usernameLength:int = ar.readInt();
            username = ar.readMultiByte(usernameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
