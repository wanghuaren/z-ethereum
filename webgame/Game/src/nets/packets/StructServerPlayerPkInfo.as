package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家pk信息
    */
    public class StructServerPlayerPkInfo implements ISerializable
    {
        /** 
        *序列
        */
        public var no:int;
        /** 
        *对手序列
        */
        public var opp_no:int;
        /** 
        *用户信息
        */
        public var userid:int;
        /** 
        *account用户信息
        */
        public var accountid:int;
        /** 
        *级别
        */
        public var level:int;
        /** 
        *玩家名称
        */
        public var name:String = new String();
        /** 
        *职业
        */
        public var metier:int;
        /** 
        *玩家头像
        */
        public var icon:int;
        /** 
        *玩家战斗力
        */
        public var fight_value:int;
        /** 
        *所在服务器
        */
        public var serverid:int;
        /** 
        *areaid所在服务器
        */
        public var areaid:int;
        /** 
        *胜利场次
        */
        public var num:int;
        /** 
        *失败场次
        */
        public var lostnum:int;
        /** 
        *玩家进度step 每2位代表一个进度 0 未比 1 胜利 2 失败
        */
        public var step:int;
        /** 
        *s0
        */
        public var s0:int;
        /** 
        *s1
        */
        public var s1:int;
        /** 
        *s2
        */
        public var s2:int;
        /** 
        *s3
        */
        public var s3:int;
        /** 
        *r1
        */
        public var r1:int;
        /** 
        *qq
        */
        public var qq:int;
        /** 
        *分数
        */
        public var coin:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(no);
            ar.writeInt(opp_no);
            ar.writeInt(userid);
            ar.writeInt(accountid);
            ar.writeInt(level);
            PacketFactory.Instance.WriteString(ar, name, 32);
            ar.writeInt(metier);
            ar.writeInt(icon);
            ar.writeInt(fight_value);
            ar.writeInt(serverid);
            ar.writeInt(areaid);
            ar.writeInt(num);
            ar.writeInt(lostnum);
            ar.writeInt(step);
            ar.writeInt(s0);
            ar.writeInt(s1);
            ar.writeInt(s2);
            ar.writeInt(s3);
            ar.writeInt(r1);
            ar.writeInt(qq);
            ar.writeInt(coin);
        }
        public function Deserialize(ar:ByteArray):void
        {
            no = ar.readInt();
            opp_no = ar.readInt();
            userid = ar.readInt();
            accountid = ar.readInt();
            level = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            metier = ar.readInt();
            icon = ar.readInt();
            fight_value = ar.readInt();
            serverid = ar.readInt();
            areaid = ar.readInt();
            num = ar.readInt();
            lostnum = ar.readInt();
            step = ar.readInt();
            s0 = ar.readInt();
            s1 = ar.readInt();
            s2 = ar.readInt();
            s3 = ar.readInt();
            r1 = ar.readInt();
            qq = ar.readInt();
            coin = ar.readInt();
        }
    }
}
