package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取全民乐翻天奖励状态
    */
    public class PacketSCGetBitTimeStatus implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 37102;
        /** 
        *获奖日志
        */
        public var tag:int;
        /** 
        *能领取的状态
        */
        public var canstatus:int;
        /** 
        *已经领取的状态
        */
        public var getstatus:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(canstatus);
            ar.writeInt(getstatus);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            canstatus = ar.readInt();
            getstatus = ar.readInt();
        }
    }
}
