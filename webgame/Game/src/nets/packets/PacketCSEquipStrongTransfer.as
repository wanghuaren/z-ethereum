package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *强化转移
    */
    public class PacketCSEquipStrongTransfer implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15045;
        /** 
        *源位置
        */
        public var srcpos:int;
        /** 
        *目标位置
        */
        public var dstpos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(srcpos);
            ar.writeInt(dstpos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            srcpos = ar.readInt();
            dstpos = ar.readInt();
        }
    }
}
