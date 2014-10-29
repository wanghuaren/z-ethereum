package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得登录天数返回
    */
    public class PacketSCGetLoginDayPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24217;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *错误信息
        */
        public var msg:String = new String();
        /** 
        *登录天数对应的奖励,从低位到高位，为1代表对应天数的奖励已领取
        */
        public var login_prize_state:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 128);
            ar.writeInt(login_prize_state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
            login_prize_state = ar.readInt();
        }
    }
}
