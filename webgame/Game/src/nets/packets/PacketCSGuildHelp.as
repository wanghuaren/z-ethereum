package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *家族救援
    */
    public class PacketCSGuildHelp implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39610;
        /** 
        *地图
        */
        public var mapid:int;
        /** 
        *地图X
        */
        public var mapx:int;
        /** 
        *地图Y
        */
        public var mapy:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(mapid);
            ar.writeInt(mapx);
            ar.writeInt(mapy);
        }
        public function Deserialize(ar:ByteArray):void
        {
            mapid = ar.readInt();
            mapx = ar.readInt();
            mapy = ar.readInt();
        }
    }
}
