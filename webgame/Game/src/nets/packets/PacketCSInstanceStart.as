package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *副本开始
    */
    public class PacketCSInstanceStart implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20015;
        /** 
        *报名id
        */
        public var signid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(signid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            signid = ar.readInt();
        }
    }
}
