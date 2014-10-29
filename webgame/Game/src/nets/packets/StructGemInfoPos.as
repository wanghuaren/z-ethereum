package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGemInfo2
    /** 
    *宝石位置信息
    */
    public class StructGemInfoPos implements ISerializable
    {
        /** 
        *位置上的宝石
        */
        public var pos:int;
        /** 
        *宝石列表
        */
        public var arrItemitems:Vector.<StructGemInfo2> = new Vector.<StructGemInfo2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(pos);
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
            pos = ar.readInt();
            arrItemitems= new  Vector.<StructGemInfo2>();
            var itemsLength:int = ar.readInt();
            for (var iitems:int=0;iitems<itemsLength; ++iitems)
            {
                var objGemInfo:StructGemInfo2 = new StructGemInfo2();
                objGemInfo.Deserialize(ar);
                arrItemitems.push(objGemInfo);
            }
        }
    }
}
