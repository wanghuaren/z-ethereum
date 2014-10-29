package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得禁言时间返回
    */
    public class PacketSCGetSayEnable implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 10021;
        /** 
        *禁言时间,格式:1301010101
        */
        public var disable_time:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(disable_time);
        }
        public function Deserialize(ar:ByteArray):void
        {
            disable_time = ar.readInt();
        }
    }
}
