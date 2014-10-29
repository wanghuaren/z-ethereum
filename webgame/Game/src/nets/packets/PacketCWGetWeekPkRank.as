package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得pk周排行榜数据
    */
    public class PacketCWGetWeekPkRank implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20058;
        /** 
        *页数
        */
        public var page:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(page);
        }
        public function Deserialize(ar:ByteArray):void
        {
            page = ar.readInt();
        }
    }
}
