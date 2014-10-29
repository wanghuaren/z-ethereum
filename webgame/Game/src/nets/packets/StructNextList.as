package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *可接任务列表
    */
    public class StructNextList implements ISerializable
    {
        /** 
        *任务编号
        */
        public var taskid:int;
        /** 
        *任务状态(1可接受2未完成3未提交4不可接5失败)
        */
        public var status:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(taskid);
            ar.writeInt(status);
        }
        public function Deserialize(ar:ByteArray):void
        {
            taskid = ar.readInt();
            status = ar.readInt();
        }
    }
}
