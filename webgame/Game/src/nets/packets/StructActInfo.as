package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructActRecInfo2
    /** 
    *活动成就信息
    */
    public class StructActInfo implements ISerializable
    {
        /** 
        *活动成就记录
        */
        public var arrItemactrecinfo:Vector.<StructActRecInfo2> = new Vector.<StructActRecInfo2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemactrecinfo.length);
            for each (var actrecinfoitem:Object in arrItemactrecinfo)
            {
                var objactrecinfo:ISerializable = actrecinfoitem as ISerializable;
                if (null!=objactrecinfo)
                {
                    objactrecinfo.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemactrecinfo= new  Vector.<StructActRecInfo2>();
            var actrecinfoLength:int = ar.readInt();
            for (var iactrecinfo:int=0;iactrecinfo<actrecinfoLength; ++iactrecinfo)
            {
                var objActRecInfo:StructActRecInfo2 = new StructActRecInfo2();
                objActRecInfo.Deserialize(ar);
                arrItemactrecinfo.push(objActRecInfo);
            }
        }
    }
}
