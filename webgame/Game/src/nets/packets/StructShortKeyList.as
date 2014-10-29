package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructShortKey2
    /** 
    *快捷键
    */
    public class StructShortKeyList implements ISerializable
    {
        /** 
        *单个快捷键
        */
        public var arrItemitem:Vector.<StructShortKey2> = new Vector.<StructShortKey2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemitem.length);
            for each (var itemitem:Object in arrItemitem)
            {
                var objitem:ISerializable = itemitem as ISerializable;
                if (null!=objitem)
                {
                    objitem.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemitem= new  Vector.<StructShortKey2>();
            var itemLength:int = ar.readInt();
            for (var iitem:int=0;iitem<itemLength; ++iitem)
            {
                var objShortKey:StructShortKey2 = new StructShortKey2();
                objShortKey.Deserialize(ar);
                arrItemitem.push(objShortKey);
            }
        }
    }
}
