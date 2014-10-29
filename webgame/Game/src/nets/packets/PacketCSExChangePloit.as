package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *功勋兑换
    */
    public class PacketCSExChangePloit implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53400;
        /** 
        *功勋id
        */
        public var index:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(index);
        }
        public function Deserialize(ar:ByteArray):void
        {
            index = ar.readInt();
        }
    }
}
