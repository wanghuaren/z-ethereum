package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *领取消费返利奖励返回
    */
    public class PacketSCGetCosumePrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38103;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *错误信息
        */
        public var msg:String = new String();
        /** 
        *消费返利领取状态
        */
        public var state:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 128);
            ar.writeInt(state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
            state = ar.readInt();
        }
    }
}
