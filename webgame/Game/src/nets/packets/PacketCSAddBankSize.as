package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *增加仓库容量
    */
    public class PacketCSAddBankSize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8020;
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
