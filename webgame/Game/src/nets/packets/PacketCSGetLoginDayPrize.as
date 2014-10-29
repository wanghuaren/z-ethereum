package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得登录天数奖励
    */
    public class PacketCSGetLoginDayPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24216;
        /** 
        *登录天数
        */
        public var login_day:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(login_day);
        }
        public function Deserialize(ar:ByteArray):void
        {
            login_day = ar.readInt();
        }
    }
}
