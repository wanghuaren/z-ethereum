package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSimpleLogRecInfo2
    /** 
    *日志信息
    */
    public class StructSimpleLogInfo implements ISerializable
    {
        /** 
        *日志记录
        */
        public var arrItemlogrecinfo:Vector.<StructSimpleLogRecInfo2> = new Vector.<StructSimpleLogRecInfo2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemlogrecinfo.length);
            for each (var logrecinfoitem:Object in arrItemlogrecinfo)
            {
                var objlogrecinfo:ISerializable = logrecinfoitem as ISerializable;
                if (null!=objlogrecinfo)
                {
                    objlogrecinfo.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemlogrecinfo= new  Vector.<StructSimpleLogRecInfo2>();
            var logrecinfoLength:int = ar.readInt();
            for (var ilogrecinfo:int=0;ilogrecinfo<logrecinfoLength; ++ilogrecinfo)
            {
                var objSimpleLogRecInfo:StructSimpleLogRecInfo2 = new StructSimpleLogRecInfo2();
                objSimpleLogRecInfo.Deserialize(ar);
                arrItemlogrecinfo.push(objSimpleLogRecInfo);
            }
        }
    }
}
