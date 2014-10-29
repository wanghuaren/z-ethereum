package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *炼骨
    */
    public class StructBoneStrong implements ISerializable
    {
        /** 
        *第几层
        */
        public var num:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            num = ar.readInt();
        }
    }
}
