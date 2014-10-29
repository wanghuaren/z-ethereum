package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *坐骑升星
    */
    public class PacketCSHorseStar implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 16020;
        /** 
        *位置
        */
        public var horsepos:int;
        /** 
        *是否可以替代
        */
        public var isrmb:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(horsepos);
            ar.writeInt(isrmb);
        }
        public function Deserialize(ar:ByteArray):void
        {
            horsepos = ar.readInt();
            isrmb = ar.readInt();
        }
    }
}
