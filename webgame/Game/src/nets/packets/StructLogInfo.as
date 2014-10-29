package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructLogRecInfo2
    /** 
    *日志信息
    */
    public class StructLogInfo implements ISerializable
    {
        /** 
        *日志记录
        */
        public var arrItemlogrecinfo:Vector.<StructLogRecInfo2> = new Vector.<StructLogRecInfo2>();

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
            arrItemlogrecinfo= new  Vector.<StructLogRecInfo2>();
            var logrecinfoLength:int = ar.readInt();
            for (var ilogrecinfo:int=0;ilogrecinfo<logrecinfoLength; ++ilogrecinfo)
            {
                var objLogRecInfo:StructLogRecInfo2 = new StructLogRecInfo2();
                objLogRecInfo.Deserialize(ar);
                arrItemlogrecinfo.push(objLogRecInfo);
            }
        }
    }
}
