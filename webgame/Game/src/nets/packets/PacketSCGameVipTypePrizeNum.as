package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取VIP类型礼包返回
    */
    public class PacketSCGameVipTypePrizeNum implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31037;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *白银VIP礼包可领次数
        */
        public var vip1_num:int;
        /** 
        *黄金VIP礼包可领次数
        */
        public var vip2_num:int;
        /** 
        *至尊VIP礼包可领次数
        */
        public var vip3_num:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(vip1_num);
            ar.writeInt(vip2_num);
            ar.writeInt(vip3_num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            vip1_num = ar.readInt();
            vip2_num = ar.readInt();
            vip3_num = ar.readInt();
        }
    }
}
