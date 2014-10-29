package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructCDKey2
    /** 
    *新手卡信息
    */
    public class StructCDKeyList implements ISerializable
    {
        /** 
        *
        */
        public var arrItemitems:Vector.<StructCDKey2> = new Vector.<StructCDKey2>();

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
            arrItemitems= new  Vector.<StructCDKey2>();
            var itemsLength:int = ar.readInt();
            for (var iitems:int=0;iitems<itemsLength; ++iitems)
            {
                var objCDKey:StructCDKey2 = new StructCDKey2();
                objCDKey.Deserialize(ar);
                arrItemitems.push(objCDKey);
            }
        }
    }
}
