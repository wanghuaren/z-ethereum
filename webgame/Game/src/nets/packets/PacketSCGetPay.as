package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取充值总金额
    */
    public class PacketSCGetPay implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31002;
        /** 
        *金额
        */
        public var pay:int;
        /** 
        *银两当日兑换的次数
        */
        public var times:int;
        /** 
        *礼包数据，低16位记录普通礼包，高16位记录扩展礼包
        */
        public var gifts:int;
        /** 
        *阅历当日兑换的次数
        */
        public var exp2times:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pay);
            ar.writeInt(times);
            ar.writeInt(gifts);
            ar.writeInt(exp2times);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pay = ar.readInt();
            times = ar.readInt();
            gifts = ar.readInt();
            exp2times = ar.readInt();
        }
    }
}
