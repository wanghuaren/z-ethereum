package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *领取悬赏任务奖励
    */
    public class PacketCSTaskAwardComplete implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 6024;
        /** 
        *任务ID
        */
        public var taskid:int;
        /** 
        *1表示双倍
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(taskid);
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            taskid = ar.readInt();
            flag = ar.readInt();
        }
    }
}
