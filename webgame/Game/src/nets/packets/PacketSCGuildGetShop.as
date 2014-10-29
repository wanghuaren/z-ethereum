package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildShopItem2
    /** 
    *获取帮派个人商店
    */
    public class PacketSCGuildGetShop implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39268;
        /** 
        *道具列表
        */
        public var arrItemitems:Vector.<StructGuildShopItem2> = new Vector.<StructGuildShopItem2>();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
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
