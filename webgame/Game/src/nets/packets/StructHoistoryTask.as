package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *任务历史
    */
    public class StructHoistoryTask implements ISerializable
    {
        /** 
        *任务编号
        */
        public var task_id:int;
        /** 
        *任务完成时间
        */
        public var task_time:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(task_id);
            ar.writeInt(task_time);
        }
        public function Deserialize(ar:ByteArray):void
        {
            task_id = ar.readInt();
            task_time = ar.readInt();
        }
    }
}
