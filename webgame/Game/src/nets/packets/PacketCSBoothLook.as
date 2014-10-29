package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *查看摊位
    */
    public class PacketCSBoothLook implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8604;
        /** 
        *卖家ID
        */
        public var seller_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(seller_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            seller_id = ar.readInt();
        }
    }
}
