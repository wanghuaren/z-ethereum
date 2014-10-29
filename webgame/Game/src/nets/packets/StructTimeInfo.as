package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *时间信息
    */
    public class StructTimeInfo implements ISerializable
    {
        /** 
        *高位32位时间
        */
        public var hi_time:int;
        /** 
        *低位32位时间
        */
        public var low_time:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(hi_time);
            ar.writeInt(low_time);
        }
        public function Deserialize(ar:ByteArray):void
        {
            hi_time = ar.readInt();
            low_time = ar.readInt();
        }
    }
}
