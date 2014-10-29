package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取全民乐翻天奖励状态
    */
    public class PacketCSGetBitTime implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 37103;
        /** 
        *索引编号1-25
        */
        public var indexid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(indexid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            indexid = ar.readInt();
        }
    }
}
