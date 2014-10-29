package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructWayPoint2
    /** 
    *对象位置矫正位置
    */
    public class PacketSCObjVerifyPos implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 11013;
        /** 
        *地图id
        */
        public var mapid:int;
        /** 
        *物体id
        */
        public var objid:int;
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
            cur_point.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            mapid = ar.readInt();
            objid = ar.readInt();
            cur_point.Deserialize(ar);
        }
    }
}
