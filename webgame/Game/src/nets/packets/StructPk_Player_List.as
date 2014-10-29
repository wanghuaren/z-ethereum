package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *pk玩家信息
    */
    public class StructPk_Player_List implements ISerializable
    {
        /** 
        *玩家id
        */
        public var userid:int;
        /** 
        *玩家名称
        */
        public var username:String = new String();
        /** 
        *状态1 空闲 2战斗
        */
        public var state:int;
        /** 
        *玩家等级
        */
        public var level:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(userid);
            PacketFactory.Instance.WriteString(ar, username, 32);
            ar.writeInt(state);
            ar.writeInt(level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            var usernameLength:int = ar.readInt();
            username = ar.readMultiByte(usernameLength,PacketFactory.Instance.GetCharSet());
            state = ar.readInt();
            level = ar.readInt();
        }
    }
}
