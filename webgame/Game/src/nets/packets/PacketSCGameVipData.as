package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取VIP特权信息返回
    */
    public class PacketSCGameVipData implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31029;
        /** 
        *VIP特权类型1表示白银，2表示黄金，3表示至尊
        */
        public var VipType:int;
        /** 
        *VIP特权结束日期
        */
        public var VipTypeEndDate:int;
        /** 
        *福利领取状态,1表示已领取，0表示尚未领取
        */
        public var GiftState:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(VipType);
            ar.writeInt(VipTypeEndDate);
            ar.writeInt(GiftState);
        }
        public function Deserialize(ar:ByteArray):void
        {
            VipType = ar.readInt();
            VipTypeEndDate = ar.readInt();
            GiftState = ar.readInt();
        }
    }
}
