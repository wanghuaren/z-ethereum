package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得剩余新双倍时间返回
    */
    public class PacketSCGetNewExpLastTime implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 43004;
        /** 
        *剩余时间 毫秒
        */
        public var exptime:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(exptime);
        }
        public function Deserialize(ar:ByteArray):void
        {
            exptime = ar.readInt();
        }
    }
}
