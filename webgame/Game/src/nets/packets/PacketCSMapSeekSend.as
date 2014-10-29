package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *地图传送
    */
    public class PacketCSMapSeekSend implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 13011;
        /** 
        *传送点ID
        */
        public var seekid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(seekid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            seekid = ar.readInt();
        }
    }
}
