package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *增加双倍经验时间
    */
    public class PacketCSDoubleExpAddTime implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 36007;
        /** 
        *增加的小时数
        */
        public var hour:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(hour);
        }
        public function Deserialize(ar:ByteArray):void
        {
            hour = ar.readInt();
        }
    }
}
