package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *珍宝阁购买
    */
    public class PacketWSTreasureShopBuy implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 51504;
        /** 
        *商品id
        */
        public var itemid:int;
        /** 
        *商品itemruler
        */
        public var itemruler:int;
        /** 
        *购买数量
        */
        public var cnt:int;
        /** 
        *售卖货币类型,1元宝，2礼金，3绑定游戏币
        */
        public var moneytype:int;
        /** 
        *商品价格
        */
        public var price:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(itemid);
            ar.writeInt(itemruler);
            ar.writeInt(cnt);
            ar.writeInt(moneytype);
            ar.writeInt(price);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemid = ar.readInt();
            itemruler = ar.readInt();
            cnt = ar.readInt();
            moneytype = ar.readInt();
            price = ar.readInt();
        }
    }
}
