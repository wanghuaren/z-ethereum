package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructWayPoint2
    /** 
    *视野内物体移动(包括人，npc)
    */
    public class PacketSCObjNewMove implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 11012;
        /** 
        *地图id
        */
        public var mapid:int;
        /** 
        *物体id
        */
        public var objid:int;
        /** 
        *移动方向
        */
        public var dir:int;
        /** 
        *移动步数 1  2
        */
        public var step:int;
        /** 
        *当前位置
        */
        public var cur_point:StructWayPoint2 = new StructWayPoint2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(mapid);
            ar.writeInt(objid);
            ar.writeInt(dir);
            ar.writeInt(step);
            cur_point.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            mapid = ar.readInt();
            objid = ar.readInt();
            dir = ar.readInt();
            step = ar.readInt();
            cur_point.Deserialize(ar);
        }
    }
}
