package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructWayPoint2
    import netc.packets2.StructWayPoint2
    /** 
    *视野内物体移动(包括人，npc)
    */
    public class PacketSCMove implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 11003;
        /** 
        *物体id
        */
        public var aid:int;
        /** 
        *是否跳跃,1表示是,0表示不是
        */
        public var isjump:int;
        /** 
        *当前位置
        */
        public var cur_point:StructWayPoint2 = new StructWayPoint2();
        /** 
        *移动到目标位置
        */
        public var way_point:StructWayPoint2 = new StructWayPoint2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(aid);
            ar.writeInt(isjump);
            cur_point.Serialize(ar);
            way_point.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            aid = ar.readInt();
            isjump = ar.readInt();
            cur_point.Deserialize(ar);
            way_point.Deserialize(ar);
        }
    }
}
