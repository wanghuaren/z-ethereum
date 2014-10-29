package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *上坐骑
    */
    public class PacketCSRideOn implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 16001;
        /** 
        *
        */
        public var horsepos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(horsepos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            horsepos = ar.readInt();
        }
    }
}
