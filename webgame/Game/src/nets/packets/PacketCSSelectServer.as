package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *选择服务器
    */
    public class PacketCSSelectServer implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 122;
        /** 
        *服务器id
        */
        public var serverid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(serverid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            serverid = ar.readInt();
        }
    }
}
