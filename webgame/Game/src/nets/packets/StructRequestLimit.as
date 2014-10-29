package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *限制查询信息
    */
    public class StructRequestLimit implements ISerializable
    {
        /** 
        *限制id
        */
        public var limitid:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(limitid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            limitid = ar.readInt();
        }
    }
}
