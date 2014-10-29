package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *任务详细信息
    */
    public class PacketCSTaskDesc implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 6010;
        /** 
        *任务编号
        */
        public var taskid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(taskid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            taskid = ar.readInt();
        }
    }
}
