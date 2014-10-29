package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *寻路中间点
    */
    public class StructSeekData implements ISerializable
    {
        /** 
        *寻路ID
        */
        public var seek_id:int;
        /** 
        *地图ID
        */
        public var map_id:int;
        /** 
        *地图坐标
        */
        public var map_x:int;
        /** 
        *地图坐标
        */
        public var map_y:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(seek_id);
            ar.writeInt(map_id);
            ar.writeInt(map_x);
            ar.writeInt(map_y);
        }
        public function Deserialize(ar:ByteArray):void
        {
            seek_id = ar.readInt();
            map_id = ar.readInt();
            map_x = ar.readInt();
            map_y = ar.readInt();
        }
    }
}
