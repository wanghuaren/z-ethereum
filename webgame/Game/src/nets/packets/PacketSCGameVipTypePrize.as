package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取VIP类型礼包返回
    */
    public class PacketSCGameVipTypePrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31035;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *错误信息
        */
        public var msg:String = new String();
        /** 
        *VIP特权类型1表示白银，2表示黄金，3表示至尊
        */
        public var VipType:int;
        /** 
        *VIP礼包剩余可领次数
        */
        public var vipNum:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 128);
            ar.writeInt(VipType);
            ar.writeInt(vipNum);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
            VipType = ar.readInt();
            vipNum = ar.readInt();
        }
    }
}
