package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *提取元宝
    */
    public class PacketCSPickUpCoin3 implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31042;
        /** 
        *提取数量
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
