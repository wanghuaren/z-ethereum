package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *添加元宝
    */
    public class PacketCSTradeAddCoin implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8659;
        /** 
        *元宝
        */
        public var coin3:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(coin3);
        }
        public function Deserialize(ar:ByteArray):void
        {
            coin3 = ar.readInt();
        }
    }
}
