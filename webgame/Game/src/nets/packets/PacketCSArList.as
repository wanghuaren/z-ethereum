package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取成就列表
    */
    public class PacketCSArList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24002;
        /** 
        *
        */
        public var ar_type:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(ar_type);
        }
        public function Deserialize(ar:ByteArray):void
        {
            ar_type = ar.readInt();
        }
    }
}
