package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *排行榜数据
    */
    public class PacketCSRankList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 28000;
        /** 
        *1.战力2.伙伴3.等级4.财富5.星魂6.成就
        */
        public var sort:int;
        /** 
        *职业,0表示全部
        */
        public var metier:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(sort);
            ar.writeInt(metier);
        }
        public function Deserialize(ar:ByteArray):void
        {
            sort = ar.readInt();
            metier = ar.readInt();
        }
    }
}
