package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructTreasureGoodsInfo2
    /** 
    *珍宝阁查询
    */
    public class PacketSCTreasureShopQuery implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 51501;
        /** 
        *所属标签
        */
        public var type:int;
        /** 
        *所属标签最新版本
        */
        public var ver:int;
        /** 
        *商品列表
        */
        public var arrItemgoodslist:Vector.<StructTreasureGoodsInfo2> = new Vector.<StructTreasureGoodsInfo2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            ar.writeInt(ver);
            ar.writeInt(arrItemgoodslist.length);
            for each (var goodslistitem:Object in arrItemgoodslist)
            {
                var objgoodslist:ISerializable = goodslistitem as ISerializable;
                if (null!=objgoodslist)
                {
                    objgoodslist.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            ver = ar.readInt();
            arrItemgoodslist= new  Vector.<StructTreasureGoodsInfo2>();
            var goodslistLength:int = ar.readInt();
            for (var igoodslist:int=0;igoodslist<goodslistLength; ++igoodslist)
            {
                var objTreasureGoodsInfo:StructTreasureGoodsInfo2 = new StructTreasureGoodsInfo2();
                objTreasureGoodsInfo.Deserialize(ar);
                arrItemgoodslist.push(objTreasureGoodsInfo);
            }
        }
    }
}
