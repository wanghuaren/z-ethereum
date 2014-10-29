package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家角色信息
    */
    public class StructAwardLog implements ISerializable
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
        *道具编号
        */
        public var ItemId:int;
        /** 
        *数量
        */
        public var ItemNum:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(userid);
            PacketFactory.Instance.WriteString(ar, username, 32);
            ar.writeInt(ItemId);
            ar.writeInt(ItemNum);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            var usernameLength:int = ar.readInt();
            username = ar.readMultiByte(usernameLength,PacketFactory.Instance.GetCharSet());
            ItemId = ar.readInt();
            ItemNum = ar.readInt();
        }
    }
}
