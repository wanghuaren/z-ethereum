package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取挂机状态返回
    */
    public class PacketSCAutoState implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 25010;
        /** 
        *是否正在自动挂机
        */
        public var isAutoFight:int;
        /** 
        *自动挂机开始时间
        */
        public var autoFightBeginTime:int;
        /** 
        *自动挂机结束时间
        */
        public var autoFightEndTime:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(isAutoFight);
            ar.writeInt(autoFightBeginTime);
            ar.writeInt(autoFightEndTime);
        }
        public function Deserialize(ar:ByteArray):void
        {
            isAutoFight = ar.readInt();
            autoFightBeginTime = ar.readInt();
            autoFightEndTime = ar.readInt();
        }
    }
}
