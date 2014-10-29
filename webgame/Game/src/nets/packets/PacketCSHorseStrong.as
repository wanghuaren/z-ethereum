package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *神兽魂器强化
    */
    public class PacketCSHorseStrong implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 16012;
        /** 
        *是否元宝替代
        */
        public var isrmb:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(isrmb);
        }
        public function Deserialize(ar:ByteArray):void
        {
            isrmb = ar.readInt();
        }
    }
}
