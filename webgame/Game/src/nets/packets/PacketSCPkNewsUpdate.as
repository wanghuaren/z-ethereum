package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家pk战报更新
    */
    public class PacketSCPkNewsUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20050;
        /** 
        *玩家id
        */
        public var userid:int;
        /** 
        *玩家名称
        */
        public var username:String = new String();
        /** 
        *对手玩家id
        */
        public var oppid:int;
        /** 
        *对手玩家名称
        */
        public var oppname:String = new String();
        /** 
        *获得金币
        */
        public var coin:int;
        /** 
        *获得声望
        */
        public var renown:int;
        /** 
        *消息id
        */
        public var msg_id:int;
        /** 
        *连胜次数
        */
        public var win:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(userid);
            PacketFactory.Instance.WriteString(ar, username, 32);
            ar.writeInt(oppid);
            PacketFactory.Instance.WriteString(ar, oppname, 32);
            ar.writeInt(coin);
            ar.writeInt(renown);
            ar.writeInt(msg_id);
            ar.writeInt(win);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            var usernameLength:int = ar.readInt();
            username = ar.readMultiByte(usernameLength,PacketFactory.Instance.GetCharSet());
            oppid = ar.readInt();
            var oppnameLength:int = ar.readInt();
            oppname = ar.readMultiByte(oppnameLength,PacketFactory.Instance.GetCharSet());
            coin = ar.readInt();
            renown = ar.readInt();
            msg_id = ar.readInt();
            win = ar.readInt();
        }
    }
}
