package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructCDKeyItem2
    /** 
    *单个新手卡信息
    */
    public class StructCDKey implements ISerializable
    {
        /** 
        *编号
        */
        public var id:int;
        /** 
        *礼包图标
        */
        public var resid:int;
        /** 
        *礼包名称
        */
        public var name:String = new String();
        /** 
        *
        */
        public var desc:String = new String();
        /** 
        *
        */
        public var arrItemitems:Vector.<StructCDKeyItem2> = new Vector.<StructCDKeyItem2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(id);
            ar.writeInt(resid);
            PacketFactory.Instance.WriteString(ar, name, 50);
            PacketFactory.Instance.WriteString(ar, desc, 512);
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
            id = ar.readInt();
            resid = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            var descLength:int = ar.readInt();
            desc = ar.readMultiByte(descLength,PacketFactory.Instance.GetCharSet());
            arrItemitems= new  Vector.<StructCDKeyItem2>();
            var itemsLength:int = ar.readInt();
            for (var iitems:int=0;iitems<itemsLength; ++iitems)
            {
                var objCDKeyItem:StructCDKeyItem2 = new StructCDKeyItem2();
                objCDKeyItem.Deserialize(ar);
                arrItemitems.push(objCDKeyItem);
            }
        }
    }
}
