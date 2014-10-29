package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *珍宝商品信息
    */
    public class StructTreasureGoodsInfo implements ISerializable
    {
        /** 
        *商品编号
        */
        public var goodsid:int;
        /** 
        *物品ID
        */
        public var itemid:int;
        /** 
        *物品分类(所属标签)
        */
        public var type:int;
        /** 
        *物品子分类(所属子标签)
        */
        public var subtype:int;
        /** 
        *标记图标
        */
        public var sign:int;
        /** 
        *货币类型(1:元宝 2:绑定元宝)
        */
        public var moneytype:int;
        /** 
        *物品原价
        */
        public var ib:int;
        /** 
        *物品打折后的价格
        */
        public var ibs:int;
        /** 
        *上架时间(YYMMDDhhmm)
        */
        public var onsaledate:int;
        /** 
        *下架时间(YYMMDDhhmm)
        */
        public var offsaledate:int;
        /** 
        *物品图标(=0取模板图标 !=0显示该配置图标)
        */
        public var icon:int;
        /** 
        *是否本地预览
        */
        public var isshow:int;
        /** 
        *本地预览信息
        */
        public var showid:int;
        /** 
        *一组的数量
        */
        public var num:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(goodsid);
            ar.writeInt(itemid);
            ar.writeInt(type);
            ar.writeInt(subtype);
            ar.writeInt(sign);
            ar.writeInt(moneytype);
            ar.writeInt(ib);
            ar.writeInt(ibs);
            ar.writeInt(onsaledate);
            ar.writeInt(offsaledate);
            ar.writeInt(icon);
            ar.writeInt(isshow);
            ar.writeInt(showid);
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            goodsid = ar.readInt();
            itemid = ar.readInt();
            type = ar.readInt();
            subtype = ar.readInt();
            sign = ar.readInt();
            moneytype = ar.readInt();
            ib = ar.readInt();
            ibs = ar.readInt();
            onsaledate = ar.readInt();
            offsaledate = ar.readInt();
            icon = ar.readInt();
            isshow = ar.readInt();
            showid = ar.readInt();
            num = ar.readInt();
        }
    }
}
