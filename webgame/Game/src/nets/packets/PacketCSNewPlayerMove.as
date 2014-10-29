package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructWayPoint2
    /** 
    *客户端移动
    */
    public class PacketCSNewPlayerMove implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 11011;
        /** 
        *地图id
        */
        public var mapid:int;
        /** 
        *移动方向
        */
        public var dir:int;
        /** 
        *移动步数1 2
        */
        public var step:int;
        /** 
        *客户端当前坐标
        */
        public var way_point:StructWayPoint2 = new StructWayPoint2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(mapid);
            ar.writeInt(dir);
            ar.writeInt(step);
            way_point.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            mapid = ar.readInt();
            dir = ar.readInt();
            step = ar.readInt();
            way_point.Deserialize(ar);
        }
    }
}
