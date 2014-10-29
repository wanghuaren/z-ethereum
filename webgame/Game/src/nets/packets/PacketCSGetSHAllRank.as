package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得个人赛比赛排名数据
    */
    public class PacketCSGetSHAllRank implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53025;
        /** 
        *请求的页数 1 开始
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
