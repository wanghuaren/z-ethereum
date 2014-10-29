package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *活动排行榜数据
    */
    public class PacketCSActRank implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29034;
        /** 
        *活动标识,1表示门派秘宝,2表示PK赛,3表示金戈铁马,4表示门派建设
        */
        public var actid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(actid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            actid = ar.readInt();
        }
    }
}
