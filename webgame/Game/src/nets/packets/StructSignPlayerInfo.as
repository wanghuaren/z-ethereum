package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家数据
    */
    public class StructSignPlayerInfo implements ISerializable
    {
        /** 
        *玩家名称
        */
        public var rolename:String = new String();
        /** 
        *玩家等级
        */
        public var level:int;
        /** 
        *玩家id
        */
        public var roleid:int;
        /** 
        *玩家头像id
        */
        public var iconid:int;

        public function Serialize(ar:ByteArray):void
        {
            PacketFactory.Instance.WriteString(ar, rolename, 32);
            ar.writeInt(level);
            ar.writeInt(roleid);
            ar.writeInt(iconid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var rolenameLength:int = ar.readInt();
            rolename = ar.readMultiByte(rolenameLength,PacketFactory.Instance.GetCharSet());
            level = ar.readInt();
            roleid = ar.readInt();
            iconid = ar.readInt();
        }
    }
}
