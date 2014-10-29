package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *研发家族珍宝
    */
    public class PacketCSActiveGuildItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39415;
        /** 
        *研发的珍宝
        */
        public var item:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(item);
        }
        public function Deserialize(ar:ByteArray):void
        {
            item = ar.readInt();
        }
    }
}
