package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *心跳
    */
    public class PacketSCHeart implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 999;
        /** 
        *服务器时间戳
        */
        public var time:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(time);
        }
        public function Deserialize(ar:ByteArray):void
        {
            time = ar.readInt();
        }
    }
}
