package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得是否有领取奖励信息
    */
    public class PacketSCHaveServerStartPrizeInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39751;
        /** 
        *是否有领取奖励 1 有 2无
        */
        public var ishave:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(ishave);
        }
        public function Deserialize(ar:ByteArray):void
        {
            ishave = ar.readInt();
        }
    }
}
