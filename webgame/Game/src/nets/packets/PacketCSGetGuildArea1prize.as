package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *领取工会领地争夺奖励1
    */
    public class PacketCSGetGuildArea1prize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 52206;
        /** 
        *地图id
        */
        public var mapid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(mapid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            mapid = ar.readInt();
        }
    }
}
