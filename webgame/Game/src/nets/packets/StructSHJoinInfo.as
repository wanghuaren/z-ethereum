package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *个人赛用户参加信息
    */
    public class StructSHJoinInfo implements ISerializable
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
        *积分
        */
        public var coin:int;
        /** 
        *黄钻
        */
        public var qqyellowvip:int;
        /** 
        *排名
        */
        public var no:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(userid);
            ar.writeInt(level);
            ar.writeInt(metier);
            ar.writeInt(sex);
            PacketFactory.Instance.WriteString(ar, name, 64);
            ar.writeInt(coin);
            ar.writeInt(qqyellowvip);
            ar.writeInt(no);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            level = ar.readInt();
            metier = ar.readInt();
            sex = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            coin = ar.readInt();
            qqyellowvip = ar.readInt();
            no = ar.readInt();
        }
    }
}
