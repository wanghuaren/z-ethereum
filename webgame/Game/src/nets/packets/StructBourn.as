package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *境界
    */
    public class StructBourn implements ISerializable
    {
        /** 
        *境界位置
        */
        public var pos:int;
        /** 
        *境界等级
        */
        public var level:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeByte(pos);
            ar.writeByte(level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readByte();
            level = ar.readByte();
        }
    }
}
