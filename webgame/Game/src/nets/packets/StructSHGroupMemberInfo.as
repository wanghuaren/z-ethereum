package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *个人赛队友信息
    */
    public class StructSHGroupMemberInfo implements ISerializable
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
        *职业
        */
        public var metier:int;
        /** 
        *性别
        */
        public var sex:int;
        /** 
        *用户名称
        */
        public var name:String = new String();
        /** 
        *排名
        */
        public var no:int;
        /** 
        *icon
        */
        public var icon:int;
        /** 
        *黄钻
        */
        public var qqyellowvip:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(userid);
            ar.writeInt(level);
            ar.writeInt(metier);
            ar.writeInt(sex);
            PacketFactory.Instance.WriteString(ar, name, 64);
            ar.writeInt(no);
            ar.writeInt(icon);
            ar.writeInt(qqyellowvip);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            level = ar.readInt();
            metier = ar.readInt();
            sex = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            no = ar.readInt();
            icon = ar.readInt();
            qqyellowvip = ar.readInt();
        }
    }
}
