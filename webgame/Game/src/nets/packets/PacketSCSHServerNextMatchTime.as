package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *SH下轮比赛开始时间
    */
    public class PacketSCSHServerNextMatchTime implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53039;
        /** 
        *SH下轮比赛开始时间，格式HHMM
        */
        public var time:int;
        /** 
        *是否是最后一场比赛
        */
        public var last:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(time);
            ar.writeInt(last);
        }
        public function Deserialize(ar:ByteArray):void
        {
            time = ar.readInt();
            last = ar.readInt();
        }
    }
}
