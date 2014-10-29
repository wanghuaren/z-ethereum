package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *排行榜奖励
    */
    public class PacketSCRankTopAward implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 28011;
        /** 
        *是否是领取奖励:1是领取奖励，0是请求奖励数据
        */
        public var award_get:int;
        /** 
        *奖励ID
        */
        public var drop_id:int;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *错误信息
        */
        public var msg:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(award_get);
            ar.writeInt(drop_id);
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            award_get = ar.readInt();
            drop_id = ar.readInt();
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
