package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *合服活动返回
    */
    public class PacketSCMergeServerDay implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53701;
        /** 
        *合服第几天
        */
        public var day:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(day);
        }
        public function Deserialize(ar:ByteArray):void
        {
            day = ar.readInt();
        }
    }
}
