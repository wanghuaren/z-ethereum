package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *服务器时间同步
    */
    public class PacketWCServerTimeSync implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 137;
        /** 
        *同步时间
        */
        public var servertime:Number;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeDouble(servertime);
        }
        public function Deserialize(ar:ByteArray):void
        {
            servertime = ar.readDouble();
        }
    }
}
