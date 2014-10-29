package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *单人副本开始
    */
    public class PacketCSSInstanceStart implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20080;
        /** 
        *地图id
        */
        public var map_id:int;
        /** 
        *地图难度 0 普通 1 英雄 2 地狱
        */
        public var map_diff:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(map_id);
            ar.writeInt(map_diff);
        }
        public function Deserialize(ar:ByteArray):void
        {
            map_id = ar.readInt();
            map_diff = ar.readInt();
        }
    }
}
