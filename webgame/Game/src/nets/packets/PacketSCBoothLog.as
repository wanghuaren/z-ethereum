package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructBoothSaleItem2
    import netc.packets2.StructBoothLeaveWord2
    /** 
    *摊位日志
    */
    public class PacketSCBoothLog implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8617;
        /** 
        *总收入
        */
        public var total_income:int;
        /** 
        *出售记录
        */
        public var arrItemsale_items:Vector.<StructBoothSaleItem2> = new Vector.<StructBoothSaleItem2>();
        /** 
        *留言记录
        */
        public var arrItemleave_words:Vector.<StructBoothLeaveWord2> = new Vector.<StructBoothLeaveWord2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(total_income);
            ar.writeInt(arrItemsale_items.length);
            for each (var sale_itemsitem:Object in arrItemsale_items)
            {
                var objsale_items:ISerializable = sale_itemsitem as ISerializable;
                if (null!=objsale_items)
                {
                    objsale_items.Serialize(ar);
                }
            }
            ar.writeInt(arrItemleave_words.length);
            for each (var leave_wordsitem:Object in arrItemleave_words)
            {
                var objleave_words:ISerializable = leave_wordsitem as ISerializable;
                if (null!=objleave_words)
                {
                    objleave_words.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            total_income = ar.readInt();
            arrItemsale_items= new  Vector.<StructBoothSaleItem2>();
            var sale_itemsLength:int = ar.readInt();
            for (var isale_items:int=0;isale_items<sale_itemsLength; ++isale_items)
            {
                var objBoothSaleItem:StructBoothSaleItem2 = new StructBoothSaleItem2();
                objBoothSaleItem.Deserialize(ar);
                arrItemsale_items.push(objBoothSaleItem);
            }
            arrItemleave_words= new  Vector.<StructBoothLeaveWord2>();
            var leave_wordsLength:int = ar.readInt();
            for (var ileave_words:int=0;ileave_words<leave_wordsLength; ++ileave_words)
            {
                var objBoothLeaveWord:StructBoothLeaveWord2 = new StructBoothLeaveWord2();
                objBoothLeaveWord.Deserialize(ar);
                arrItemleave_words.push(objBoothLeaveWord);
            }
        }
    }
}
