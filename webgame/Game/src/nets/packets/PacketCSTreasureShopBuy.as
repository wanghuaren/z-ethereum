package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *珍宝阁购买
    */
    public class PacketCSTreasureShopBuy implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 51502;
        /** 
        *商品id
        */
        public var goodsid:int;
        /** 
        *购买数量
        */
        public var cnt:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(goodsid);
            ar.writeInt(cnt);
        }
        public function Deserialize(ar:ByteArray):void
        {
            goodsid = ar.readInt();
            cnt = ar.readInt();
        }
    }
}
