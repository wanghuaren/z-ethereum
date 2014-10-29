package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *设置PK模式
    */
    public class PacketCSPkMode implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14031;
        /** 
        *0表示和平模式，1表示阵营模式，2表示家族模式，3表示全体模式
        */
        public var mode:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(mode);
        }
        public function Deserialize(ar:ByteArray):void
        {
            mode = ar.readInt();
        }
    }
}
