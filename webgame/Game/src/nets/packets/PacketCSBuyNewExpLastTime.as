package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *购买新双倍时间
    */
    public class PacketCSBuyNewExpLastTime implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 43001;
        /** 
        *购买数量
        */
        public var buy_num:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(buy_num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            buy_num = ar.readInt();
        }
    }
}
