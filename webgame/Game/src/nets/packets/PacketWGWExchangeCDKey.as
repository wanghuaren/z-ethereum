package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructRmbShopItem2
    /** 
    *兑换CDKey礼包
    */
    public class PacketWGWExchangeCDKey implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31024;
        /** 
        *账号ID
        */
        public var accountid:int;
        /** 
        *物品列表
        */
        public var arrItemitemList:Vector.<StructRmbShopItem2> = new Vector.<StructRmbShopItem2>();
        /** 
        *物品ruler
        */
        public var arrItemitemRuler:Vector.<int> = new Vector.<int>();
        /** 
        *key
        */
        public var cdkey:String = new String();
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(accountid);
            ar.writeInt(arrItemitemList.length);
            for each (var itemListitem:Object in arrItemitemList)
            {
                var objitemList:ISerializable = itemListitem as ISerializable;
                if (null!=objitemList)
                {
                    objitemList.Serialize(ar);
                }
            }
            ar.writeInt(arrItemitemRuler.length);
            for each (var itemRuleritem:int in arrItemitemRuler)
            {
                ar.writeInt(itemRuleritem);
            }
            PacketFactory.Instance.WriteString(ar, cdkey, 128);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            accountid = ar.readInt();
            arrItemitemList= new  Vector.<StructRmbShopItem2>();
            var itemListLength:int = ar.readInt();
            for (var iitemList:int=0;iitemList<itemListLength; ++iitemList)
            {
                var objRmbShopItem:StructRmbShopItem2 = new StructRmbShopItem2();
                objRmbShopItem.Deserialize(ar);
                arrItemitemList.push(objRmbShopItem);
            }
            arrItemitemRuler= new  Vector.<int>();
            var itemRulerLength:int = ar.readInt();
            for (var iitemRuler:int=0;iitemRuler<itemRulerLength; ++iitemRuler)
            {
                arrItemitemRuler.push(ar.readInt());
            }
            var cdkeyLength:int = ar.readInt();
            cdkey = ar.readMultiByte(cdkeyLength,PacketFactory.Instance.GetCharSet());
            tag = ar.readInt();
        }
    }
}
