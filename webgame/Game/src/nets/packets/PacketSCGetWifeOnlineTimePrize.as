package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *领取夫妻在线奖励返回
    */
    public class PacketSCGetWifeOnlineTimePrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54103;
        /** 
        *当前是否可以领取 1 可领取 0 不能领取 2 今日无法领取
        */
        public var is_get:int;
        /** 
        *结果
        */
        public var tag:int;
        /** 
        *信息
        */
        public var msg:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(is_get);
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 256);
        }
        public function Deserialize(ar:ByteArray):void
        {
            is_get = ar.readInt();
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
