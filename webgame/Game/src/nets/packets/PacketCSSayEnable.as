package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *禁言
    */
    public class PacketCSSayEnable implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 10019;
        /** 
        *0表示禁言
        */
        public var enable:int;
        /** 
        *禁言时间
        */
        public var enable_time:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(enable);
            ar.writeInt(enable_time);
        }
        public function Deserialize(ar:ByteArray):void
        {
            enable = ar.readInt();
            enable_time = ar.readInt();
        }
    }
}
