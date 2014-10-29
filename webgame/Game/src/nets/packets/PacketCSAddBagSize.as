package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *增加背包格
    */
    public class PacketCSAddBagSize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8003;
        /** 
        *数量
        */
        public var num:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            num = ar.readInt();
        }
    }
}
