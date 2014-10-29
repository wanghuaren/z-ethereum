package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *接受任务事件
    */
    public class PacketSCTaskAcceptEvent implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 6018;
        /** 
        *任务ID
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
