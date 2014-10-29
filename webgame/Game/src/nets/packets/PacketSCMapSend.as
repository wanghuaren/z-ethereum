package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *地图NPC传送
    */
    public class PacketSCMapSend implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 13004;
        /** 
        *地图
        */
        public var mapid:int;
        /** 
        *X坐标
        */
        public var mapx:int;
        /** 
        *Y坐标
        */
        public var mapy:int;
        /** 
        *寻路ID
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
