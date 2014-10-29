package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *地图NPC传送
    */
    public class PacketCSMapSend implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 13003;
        /** 
        *传送点ID
        */
        public var sendid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(sendid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            sendid = ar.readInt();
        }
    }
}
