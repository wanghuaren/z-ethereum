package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *进入家族家园
    */
    public class PacketCSEntryGuildHome implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39400;
        /** 
        *进入类型,0为进入家园,1为进入神树,2为进入我爱我家
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            flag = ar.readInt();
        }
    }
}
