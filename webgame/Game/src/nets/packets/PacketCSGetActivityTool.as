package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *领取奖励道具
    */
    public class PacketCSGetActivityTool implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24203;
        /** 
        *领取的序列id
        */
        public var seqid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(seqid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            seqid = ar.readInt();
        }
    }
}
