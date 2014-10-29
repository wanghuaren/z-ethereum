package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *个人赛匹配用户信息
    */
    public class StructSHMatchInfo implements ISerializable
    {
        /** 
        *用户id
        */
        public var userid:int;
        /** 
        *等级
        */
        public var level:int;
        /** 
        *头像
        */
        public var icon:int;
        /** 
        *用户名称
        */
        public var name:String = new String();
        /** 
        *黄钻
        */
        public var qqyellowvip:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(userid);
            ar.writeInt(level);
            ar.writeInt(icon);
            PacketFactory.Instance.WriteString(ar, name, 64);
            ar.writeInt(qqyellowvip);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            level = ar.readInt();
            icon = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            qqyellowvip = ar.readInt();
        }
    }
}
