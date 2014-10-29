package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *地图传送点
    */
    public class StructMapSeek implements ISerializable
    {
        /** 
        *传送点名称
        */
        public var seek_name:String = new String();
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
        /** 
        *传送点索引
        */
        public var seek_id:int;

        public function Serialize(ar:ByteArray):void
        {
            PacketFactory.Instance.WriteString(ar, seek_name, 128);
            ar.writeInt(map_id);
            ar.writeInt(map_x);
            ar.writeInt(map_y);
            ar.writeInt(seek_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var seek_nameLength:int = ar.readInt();
            seek_name = ar.readMultiByte(seek_nameLength,PacketFactory.Instance.GetCharSet());
            map_id = ar.readInt();
            map_x = ar.readInt();
            map_y = ar.readInt();
            seek_id = ar.readInt();
        }
    }
}
