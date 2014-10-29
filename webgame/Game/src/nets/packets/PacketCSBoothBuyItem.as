package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *购买摆摊物品
    */
    public class PacketCSBoothBuyItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8610;
        /** 
        *卖家ID
        */
        public var seller_id:int;
        /** 
        *物品位置
        */
        public var pos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(seller_id);
            ar.writeInt(pos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            seller_id = ar.readInt();
            pos = ar.readInt();
        }
    }
}
