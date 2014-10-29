package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *字符日志记录
    */
    public class StructCharLogRecInfo implements ISerializable
    {
        /** 
        *日志类型
        */
        public var logtype:int;
        /** 
        *字符串
        */
        public var para:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(logtype);
            PacketFactory.Instance.WriteString(ar, para, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            logtype = ar.readInt();
            var paraLength:int = ar.readInt();
            para = ar.readMultiByte(paraLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
