package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *任务完成进度
    */
    public class StructTaskState implements ISerializable
    {
        /** 
        *当前进度
        */
        public var num:int;
        /** 
        *是否完成1.完成0.未完成
        */
        public var state:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(num);
            ar.writeByte(state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            num = ar.readInt();
            state = ar.readByte();
        }
    }
}
