package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *阵营排行榜积分
    */
    public class StructCampPoint implements ISerializable
    {
        /** 
        *太乙阵营积分
        */
        public var point1:int;
        /** 
        *通天阵营积分
        */
        public var point2:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(point1);
            ar.writeInt(point2);
        }
        public function Deserialize(ar:ByteArray):void
        {
            point1 = ar.readInt();
            point2 = ar.readInt();
        }
    }
}
