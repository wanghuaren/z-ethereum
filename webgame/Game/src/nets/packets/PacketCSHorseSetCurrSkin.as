package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *设置当前位置
    */
    public class PacketCSHorseSetCurrSkin implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 16039;
        /** 
        *位置，当前页，1，2,3,4,5
        */
        public var page:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(page);
        }
        public function Deserialize(ar:ByteArray):void
        {
            page = ar.readInt();
        }
    }
}
