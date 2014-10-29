package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得连续登陆天数信息
    */
    public class PacketSCContinueLoginDays implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 42304;
        /** 
        *连续登陆天数
        */
        public var days:int;
        /** 
        *奖励状态，bit[n] 0 第n个奖励未领，1 已领取
        */
        public var prize:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(days);
            ar.writeInt(prize);
        }
        public function Deserialize(ar:ByteArray):void
        {
            days = ar.readInt();
            prize = ar.readInt();
        }
    }
}
