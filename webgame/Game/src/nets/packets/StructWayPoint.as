package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *行走路点列表
    */
    public class StructWayPoint implements ISerializable
    {
        /** 
        *x坐标
        */
        public var point_x:int;
        /** 
        *y坐标
        */
        public var point_y:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(point_x);
            ar.writeInt(point_y);
        }
        public function Deserialize(ar:ByteArray):void
        {
            point_x = ar.readInt();
            point_y = ar.readInt();
        }
    }
}
