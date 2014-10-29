package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructWayPoint2
    /** 
    *视野内物体移动停止(包括人，npc)
    */
    public class PacketSCMoveStop implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 11004;
        /** 
        *物体id
        */
        public var aid:int;
        /** 
        *物体方向
        */
        public var adirect:Number;
        /** 
        *停止位置
        */
        public var stop_point:StructWayPoint2 = new StructWayPoint2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(aid);
            ar.writeFloat(adirect);
            stop_point.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            aid = ar.readInt();
            adirect = ar.readFloat();
            stop_point.Deserialize(ar);
        }
    }
}
