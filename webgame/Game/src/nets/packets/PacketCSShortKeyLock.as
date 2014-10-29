package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *快捷键锁定/解锁
    */
    public class PacketCSShortKeyLock implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8805;
        /** 
        *0:解锁 1:锁定
        */
        public var onoff:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(onoff);
        }
        public function Deserialize(ar:ByteArray):void
        {
            onoff = ar.readInt();
        }
    }
}
