package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *检查摊位是否存在
    */
    public class PacketCSBoothCheckExist implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8622;
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
