package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructRmbShopSell2
    /** 
    *获取新的手气榜
    */
    public class PacketWCSellRecord implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 32006;
        /** 
        *手气榜列表
        */
        public var arrItemsell_record:Vector.<StructRmbShopSell2> = new Vector.<StructRmbShopSell2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemsell_record.length);
            for each (var sell_recorditem:Object in arrItemsell_record)
            {
                var objsell_record:ISerializable = sell_recorditem as ISerializable;
                if (null!=objsell_record)
                {
                    objsell_record.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemsell_record= new  Vector.<StructRmbShopSell2>();
            var sell_recordLength:int = ar.readInt();
            for (var isell_record:int=0;isell_record<sell_recordLength; ++isell_record)
            {
                var objRmbShopSell:StructRmbShopSell2 = new StructRmbShopSell2();
                objRmbShopSell.Deserialize(ar);
                arrItemsell_record.push(objRmbShopSell);
            }
        }
    }
}
