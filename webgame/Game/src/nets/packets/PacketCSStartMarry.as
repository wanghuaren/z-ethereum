package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *请求结婚
    */
    public class PacketCSStartMarry implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54000;
        /** 
        *婚礼类型 1 2 3 4
        */
        public var sort:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(sort);
        }
        public function Deserialize(ar:ByteArray):void
        {
            sort = ar.readInt();
        }
    }
}
