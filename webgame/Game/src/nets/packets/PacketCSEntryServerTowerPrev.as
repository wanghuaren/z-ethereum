package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *进入server tower 上一层
    */
    public class PacketCSEntryServerTowerPrev implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 41009;
        /** 
        *地图id
        */
        public var map_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(map_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            map_id = ar.readInt();
        }
    }
}
