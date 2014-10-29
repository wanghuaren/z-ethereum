package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *进入工会领地争夺1
    */
    public class PacketCSEntryGuildArea1 implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 52202;
        /** 
        *进入的地图id
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
