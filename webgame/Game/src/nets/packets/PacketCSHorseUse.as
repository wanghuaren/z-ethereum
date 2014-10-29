package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *使用坐骑
    */
    public class PacketCSHorseUse implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 16010;
        /** 
        *坐骑再背包中的位置
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
