package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *更新比赛结果
    */
    public class PacketSCUpdateServerPKResult implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 40019;
        /** 
        *押注阶段
        */
        public var step:int;
        /** 
        *比分1
        */
        public var no1:int;
        /** 
        *比分2
        */
        public var no2:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(step);
            ar.writeInt(no1);
            ar.writeInt(no2);
        }
        public function Deserialize(ar:ByteArray):void
        {
            step = ar.readInt();
            no1 = ar.readInt();
            no2 = ar.readInt();
        }
    }
}
