package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructRmbShopItem2
    /** 
    *获取售卖列表
    */
    public class PacketSCGetRmbShopList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 32002;
        /** 
        *列表
        */
        public var arrItemitem_list:Vector.<StructRmbShopItem2> = new Vector.<StructRmbShopItem2>();
        /** 
        *刷新时间
        */
        public var times:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arrItemitem_list.length);
            for each (var item_listitem:Object in arrItemitem_list)
            {
                var objitem_list:ISerializable = item_listitem as ISerializable;
                if (null!=objitem_list)
                {
                    objitem_list.Serialize(ar);
                }
            }
            ar.writeInt(times);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemitem_list= new  Vector.<StructRmbShopItem2>();
            var item_listLength:int = ar.readInt();
            for (var iitem_list:int=0;iitem_list<item_listLength; ++iitem_list)
            {
                var objRmbShopItem:StructRmbShopItem2 = new StructRmbShopItem2();
                objRmbShopItem.Deserialize(ar);
                arrItemitem_list.push(objRmbShopItem);
            }
            times = ar.readInt();
        }
    }
}
