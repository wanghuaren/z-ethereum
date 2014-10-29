package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家加入离开更新
    */
    public class PacketWCJoinLeftUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20053;
        /** 
        *玩家id
        */
        public var userid:int;
        /** 
        *玩家名称
        */
        public var username:String = new String();
        /** 
        *阵营
        */
        public var camp:int;
        /** 
        *状态1 加入 2离开
        */
        public var state:int;
        /** 
        *玩家等级
        */
        public var level:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(userid);
            PacketFactory.Instance.WriteString(ar, username, 32);
            ar.writeInt(camp);
            ar.writeInt(state);
            ar.writeInt(level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            var usernameLength:int = ar.readInt();
            username = ar.readMultiByte(usernameLength,PacketFactory.Instance.GetCharSet());
            camp = ar.readInt();
            state = ar.readInt();
            level = ar.readInt();
        }
    }
}
