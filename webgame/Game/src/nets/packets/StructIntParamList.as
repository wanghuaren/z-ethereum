package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *回调整形参数列表
    */
    public class StructIntParamList implements ISerializable
    {
        /** 
        *整形参数
        */
        public var intparam:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(intparam);
        }
        public function Deserialize(ar:ByteArray):void
        {
            intparam = ar.readInt();
        }
    }
}
