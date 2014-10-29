package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildShopItem2
    /** 
    *帮派商店
    */
    public class StructGuildShop implements ISerializable
    {
        /** 
        *道具编号
        */
        public var arrItemitems:Vector.<StructGuildShopItem2> = new Vector.<StructGuildShopItem2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemitems.length);
            for each (var itemsitem:Object in arrItemitems)
            {
                var objitems:ISerializable = itemsitem as ISerializable;
                if (null!=objitems)
                {
                    objitems.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemitems= new  Vector.<StructGuildShopItem2>();
            var itemsLength:int = ar.readInt();
            for (var iitems:int=0;iitems<itemsLength; ++iitems)
            {
                var objGuildShopItem:StructGuildShopItem2 = new StructGuildShopItem2();
                objGuildShopItem.Deserialize(ar);
                arrItemitems.push(objGuildShopItem);
            }
        }
    }
}
