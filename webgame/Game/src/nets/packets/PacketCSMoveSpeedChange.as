package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *移动速度改变
    */
    public class PacketCSMoveSpeedChange implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 11010;
        /** 
        *地图id
        */
        public var mapid:int;
        /** 
        *移动速度改变 0 走 1 跑
        */
        public var movespeed:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(mapid);
            ar.writeInt(movespeed);
        }
        public function Deserialize(ar:ByteArray):void
        {
            mapid = ar.readInt();
            movespeed = ar.readInt();
        }
    }
}
