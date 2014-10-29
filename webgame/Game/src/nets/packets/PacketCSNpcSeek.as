package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *地图寻路列表
    */
    public class PacketCSNpcSeek implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 13007;
        /** 
        *地图
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
