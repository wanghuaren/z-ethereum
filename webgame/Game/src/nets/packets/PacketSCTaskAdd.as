package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *增加任务
    */
    public class PacketSCTaskAdd implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 6015;
        /** 
        *任务id
        */
        public var taskid:int;
        /** 
        *任务状态
        */
        public var status:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
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
