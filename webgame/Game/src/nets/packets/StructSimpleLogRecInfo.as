package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *日志记录
    */
    public class StructSimpleLogRecInfo implements ISerializable
    {
        /** 
        *日志类型
        */
        public var logtype:int;
        /** 
        *次数
        */
        public var count:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(logtype);
            ar.writeInt(count);
        }
        public function Deserialize(ar:ByteArray):void
        {
            logtype = ar.readInt();
            count = ar.readInt();
        }
    }
}
