package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得仙道会的排行数据
    */
    public class PacketCSGetServerPKRankList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53049;
        /** 
        *界数id 并非是序号id
        */
        public var no:int;
        /** 
        *时间
        */
        public var time:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(no);
            ar.writeInt(time);
        }
        public function Deserialize(ar:ByteArray):void
        {
            no = ar.readInt();
            time = ar.readInt();
        }
    }
}
