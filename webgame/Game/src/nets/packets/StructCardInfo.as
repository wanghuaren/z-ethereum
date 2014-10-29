package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructCardData2
    /** 
    *卡片
    */
    public class StructCardInfo implements ISerializable
    {
        /** 
        *数据
        */
        public var arrItemcard:Vector.<StructCardData2> = new Vector.<StructCardData2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemcard.length);
            for each (var carditem:Object in arrItemcard)
            {
                var objcard:ISerializable = carditem as ISerializable;
                if (null!=objcard)
                {
                    objcard.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemcard= new  Vector.<StructCardData2>();
            var cardLength:int = ar.readInt();
            for (var icard:int=0;icard<cardLength; ++icard)
            {
                var objCardData:StructCardData2 = new StructCardData2();
                objCardData.Deserialize(ar);
                arrItemcard.push(objCardData);
            }
        }
    }
}
