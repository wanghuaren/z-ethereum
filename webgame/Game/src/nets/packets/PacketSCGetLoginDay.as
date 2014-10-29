package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得登录天数返回
    */
    public class PacketSCGetLoginDay implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24214;
        /** 
        *登录天数
        */
        public var login_day:int;
        /** 
        *登录天数对应的奖励,从低位到高位，为1代表对应天数的奖励已领取
        */
        public var login_prize_state:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(login_day);
            ar.writeInt(login_prize_state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            login_day = ar.readInt();
            login_prize_state = ar.readInt();
        }
    }
}
