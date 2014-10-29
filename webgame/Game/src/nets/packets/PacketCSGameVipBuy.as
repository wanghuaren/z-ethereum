package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *购买VIP特权时间
    */
    public class PacketCSGameVipBuy implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31026;
        /** 
        *VIP特权类型1表示白银，2表示黄金，3表示至尊
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            flag = ar.readInt();
        }
    }
}
