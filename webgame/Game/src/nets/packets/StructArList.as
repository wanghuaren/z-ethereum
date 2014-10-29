package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *成就列表
    */
    public class StructArList implements ISerializable
    {
        /** 
        *成就id
        */
        public var ar_id:int;
        /** 
        *成就状态1开始2完成3失败0未开启
        */
        public var ar_state:int;
        /** 
        *成就完成度
        */
        public var ar_schedule:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(ar_id);
            ar.writeInt(ar_state);
            ar.writeInt(ar_schedule);
        }
        public function Deserialize(ar:ByteArray):void
        {
            ar_id = ar.readInt();
            ar_state = ar.readInt();
            ar_schedule = ar.readInt();
        }
    }
}
