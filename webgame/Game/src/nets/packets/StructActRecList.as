package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *活动记录列表
    */
    public class StructActRecList implements ISerializable
    {
        /** 
        *活动id
        */
        public var arid:int;
        /** 
        *次数
        */
        public var count:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arid);
            ar.writeInt(count);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arid = ar.readInt();
            count = ar.readInt();
        }
    }
}
