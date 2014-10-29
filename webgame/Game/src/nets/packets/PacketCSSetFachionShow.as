package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *设置时装是否显示
    */
    public class PacketCSSetFachionShow implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8038;
        /** 
        *0不显示，1显示
        */
        public var value:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(value);
        }
        public function Deserialize(ar:ByteArray):void
        {
            value = ar.readInt();
        }
    }
}
