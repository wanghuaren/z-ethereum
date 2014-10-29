package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *角色切换地图
    */
    public class PacketCSRoleChangeMap implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 1001;
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
        /** 
        *seekid
        */
        public var seekid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(mapid);
            ar.writeInt(mapx);
            ar.writeInt(mapy);
            ar.writeInt(seekid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            mapid = ar.readInt();
            mapx = ar.readInt();
            mapy = ar.readInt();
            seekid = ar.readInt();
        }
    }
}
