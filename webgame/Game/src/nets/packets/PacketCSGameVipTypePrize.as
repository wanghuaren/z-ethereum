package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取VIP类型礼包
    */
    public class PacketCSGameVipTypePrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31034;
        /** 
        *VIP特权类型1表示白银，2表示黄金，3表示至尊
        */
        public var VipType:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(VipType);
        }
        public function Deserialize(ar:ByteArray):void
        {
            VipType = ar.readInt();
        }
    }
}
