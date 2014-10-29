package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *在指定位置释放技能效果
    */
    public class PacketSCCastSkillEffect implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 51000;
        /** 
        *效果id
        */
        public var effid:int;
        /** 
        *地图id
        */
        public var mapid:int;
        /** 
        *坐标x
        */
        public var mapx:int;
        /** 
        *坐标y
        */
        public var mapy:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(effid);
            ar.writeInt(mapid);
            ar.writeInt(mapx);
            ar.writeInt(mapy);
        }
        public function Deserialize(ar:ByteArray):void
        {
            effid = ar.readInt();
            mapid = ar.readInt();
            mapx = ar.readInt();
            mapy = ar.readInt();
        }
    }
}
