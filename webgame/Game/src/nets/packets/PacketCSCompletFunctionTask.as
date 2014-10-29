package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *完成特殊功能任务
    */
    public class PacketCSCompletFunctionTask implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39809;
        /** 
        *任务id
        */
        public var task_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(task_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            task_id = ar.readInt();
        }
    }
}
