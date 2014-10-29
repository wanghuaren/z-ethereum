package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得婚礼免费礼包
    */
    public class PacketCSGetMarryPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54009;
        /** 
        *索引
        */
        public var index:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(index);
        }
        public function Deserialize(ar:ByteArray):void
        {
            index = ar.readInt();
        }
    }
}
