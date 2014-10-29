package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *对方请求结婚结果
    */
    public class PacketCSOppReadyMarry implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54003;
        /** 
        *是否同意和对方结婚 1 同意 2 不同意
        */
        public var isok:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(isok);
        }
        public function Deserialize(ar:ByteArray):void
        {
            isok = ar.readInt();
        }
    }
}
