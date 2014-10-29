package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *成就分类点数数据
    */
    public class StructAr_Sub_Point implements ISerializable
    {
        /** 
        *成就点数
        */
        public var ar_sub_point:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(ar_sub_point);
        }
        public function Deserialize(ar:ByteArray):void
        {
            ar_sub_point = ar.readInt();
        }
    }
}
