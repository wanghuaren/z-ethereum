package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *摆摊出售记录
    */
    public class StructBoothSaleItem implements ISerializable
    {
        /** 
        *时间
        */
        public var time:int;
        /** 
        *物品id
        */
        public var itemid:int;
        /** 
        *数量
        */
        public var count:int;
        /** 
        *价格
        */
        public var price:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(time);
            ar.writeInt(itemid);
            ar.writeInt(count);
            ar.writeInt(price);
        }
        public function Deserialize(ar:ByteArray):void
        {
            time = ar.readInt();
            itemid = ar.readInt();
            count = ar.readInt();
            price = ar.readInt();
        }
    }
}
