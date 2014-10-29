package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取春节活动排行榜
    */
    public class PacketCSGetChineseNewYearRank implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38106;
        /** 
        *0表示日排行榜,1表示总榜
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
        }
    }
}
