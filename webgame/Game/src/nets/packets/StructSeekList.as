package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *地图寻路点
    */
    public class StructSeekList implements ISerializable
    {
        /** 
        *寻路编号
        */
        public var seek_id:int;
        /** 
        *类别:1功能分页2剧情分页3怪物分页
        */
        public var sort:int;
        /** 
        *顺序
        */
        public var pos:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(seek_id);
            ar.writeInt(sort);
            ar.writeInt(pos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            seek_id = ar.readInt();
            sort = ar.readInt();
            pos = ar.readInt();
        }
    }
}
