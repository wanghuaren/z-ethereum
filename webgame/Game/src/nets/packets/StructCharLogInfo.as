package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructCharLogRecInfo2
    /** 
    *字符日志
    */
    public class StructCharLogInfo implements ISerializable
    {
        /** 
        *字符日志记录
        */
        public var arrItemcharlogrecinfo:Vector.<StructCharLogRecInfo2> = new Vector.<StructCharLogRecInfo2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemcharlogrecinfo.length);
            for each (var charlogrecinfoitem:Object in arrItemcharlogrecinfo)
            {
                var objcharlogrecinfo:ISerializable = charlogrecinfoitem as ISerializable;
                if (null!=objcharlogrecinfo)
                {
                    objcharlogrecinfo.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemcharlogrecinfo= new  Vector.<StructCharLogRecInfo2>();
            var charlogrecinfoLength:int = ar.readInt();
            for (var icharlogrecinfo:int=0;icharlogrecinfo<charlogrecinfoLength; ++icharlogrecinfo)
            {
                var objCharLogRecInfo:StructCharLogRecInfo2 = new StructCharLogRecInfo2();
                objCharLogRecInfo.Deserialize(ar);
                arrItemcharlogrecinfo.push(objCharLogRecInfo);
            }
        }
    }
}
