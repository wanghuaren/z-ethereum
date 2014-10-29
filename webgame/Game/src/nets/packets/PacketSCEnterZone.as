package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *进入区域
    */
    public class PacketSCEnterZone implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 1014;
        /** 
        *区域id
        */
        public var zoneid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(zoneid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            zoneid = ar.readInt();
        }
    }
}
