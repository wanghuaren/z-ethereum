package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *地图传送点列表
    */
    public class PacketCSMapSeek implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 13001;
        /** 
        *地图ID
        */
        public var mapid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(mapid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            mapid = ar.readInt();
        }
    }
}
