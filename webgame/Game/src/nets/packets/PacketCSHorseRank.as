package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *坐骑进阶
    */
    public class PacketCSHorseRank implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 16008;
        /** 
        *位置
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
