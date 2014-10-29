package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *悬赏任务列表
    */
    public class StructAwardTaskList implements ISerializable
    {
        /** 
        *任务编号
        */
        public var taskid:int;
        /** 
        *星级
        */
        public var star:int;
        /** 
        *当前状态1表示可接取,2表示已接取未完成,3表示已完成,4表示已接取
        */
        public var state:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(taskid);
            ar.writeInt(star);
            ar.writeInt(state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            taskid = ar.readInt();
            star = ar.readInt();
            state = ar.readInt();
        }
    }
}
