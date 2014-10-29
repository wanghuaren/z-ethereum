package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *客户端移动主动停止
    */
    public class PacketCSPlayerMoveStop implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 11006;
        /** 
        *地图id
        */
        public var mapid:int;
        /** 
        *X坐标
        */
        public var posx:int;
        /** 
        *y坐标
        */
        public var posy:int;
        /** 
        *方向
        */
        public var dir:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(mapid);
            ar.writeInt(posx);
            ar.writeInt(posy);
            ar.writeInt(dir);
        }
        public function Deserialize(ar:ByteArray):void
        {
            mapid = ar.readInt();
            posx = ar.readInt();
            posy = ar.readInt();
            dir = ar.readInt();
        }
    }
}
