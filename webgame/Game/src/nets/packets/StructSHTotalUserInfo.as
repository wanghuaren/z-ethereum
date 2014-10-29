package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *个人赛总排名用户信息
    */
    public class StructSHTotalUserInfo implements ISerializable
    {
        /** 
        *用户id
        */
        public var userid:int;
        /** 
        *用户accountid
        */
        public var accountid:int;
        /** 
        *等级
        */
        public var level:int;
        /** 
        *职业
        */
        public var metier:int;
        /** 
        *积分
        */
        public var coin:int;
        /** 
        *本周参与次数
        */
        public var weekjoin:int;
        /** 
        *本周胜利次数
        */
        public var weekwin:int;
        /** 
        *排名
        */
        public var no:int;
        /** 
        *用户icon
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
            ar.writeInt(accountid);
            ar.writeInt(level);
            ar.writeInt(metier);
            ar.writeInt(coin);
            ar.writeInt(weekjoin);
            ar.writeInt(weekwin);
            ar.writeInt(no);
            ar.writeInt(icon);
            PacketFactory.Instance.WriteString(ar, name, 64);
            ar.writeInt(qqyellowvip);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            accountid = ar.readInt();
            level = ar.readInt();
            metier = ar.readInt();
            coin = ar.readInt();
            weekjoin = ar.readInt();
            weekwin = ar.readInt();
            no = ar.readInt();
            icon = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            qqyellowvip = ar.readInt();
        }
    }
}
