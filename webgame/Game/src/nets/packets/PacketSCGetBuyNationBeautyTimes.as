package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *得到额外全国押运次数返回
    */
    public class PacketSCGetBuyNationBeautyTimes implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54703;
        /** 
        *当前次数
        */
        public var curtimes:int;
        /** 
        *当前已经拉镖次数
        */
        public var curtimes1:int;
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(curtimes);
            ar.writeInt(curtimes1);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            curtimes = ar.readInt();
            curtimes1 = ar.readInt();
            tag = ar.readInt();
        }
    }
}
