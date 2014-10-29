package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *检查摊位是否存在
    */
    public class PacketSCBoothCheckExist implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8623;
        /** 
        *卖家ID
        */
        public var seller_id:int;
        /** 
        *是否存在 0:存在 1:不存在
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(seller_id);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            seller_id = ar.readInt();
            tag = ar.readInt();
        }
    }
}
