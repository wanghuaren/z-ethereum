package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得世界等级返回
    */
    public class PacketSCGetWorldLevel implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39706;
        /** 
        *等级
        */
        public var level:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            level = ar.readInt();
        }
    }
}
