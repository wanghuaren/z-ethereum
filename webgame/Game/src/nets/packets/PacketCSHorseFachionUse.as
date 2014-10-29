package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *穿坐骑时装
    */
    public class PacketCSHorseFachionUse implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 16035;
        /** 
        *位置
        */
        public var fachionpos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(fachionpos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            fachionpos = ar.readInt();
        }
    }
}
