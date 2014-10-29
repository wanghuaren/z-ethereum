package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *任务取消
    */
    public class PacketCSTaskCancel implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 6008;
        /** 
        *玩家编号
        */
        public var userid:int;
        /** 
        *任务编号
        */
        public var taskid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(userid);
            ar.writeInt(taskid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            taskid = ar.readInt();
        }
    }
}
