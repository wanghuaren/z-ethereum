package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *冷却时间
    */
    public class StructCooldown implements ISerializable
    {
        /** 
        *冷却编号
        */
        public var id:int;
        /** 
        *需要冷却时间
        */
        public var needtime:int;
        /** 
        *已冷却时间
        */
        public var elapsed:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(id);
            ar.writeInt(needtime);
            ar.writeInt(elapsed);
        }
        public function Deserialize(ar:ByteArray):void
        {
            id = ar.readInt();
            needtime = ar.readInt();
            elapsed = ar.readInt();
        }
    }
}
