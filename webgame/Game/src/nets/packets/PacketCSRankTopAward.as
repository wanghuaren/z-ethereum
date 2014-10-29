package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *排行榜奖励
    */
    public class PacketCSRankTopAward implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 28010;
        /** 
        *是否是领取奖励:1是领取奖励，0是请求奖励数据
        */
        public var award_get:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(award_get);
        }
        public function Deserialize(ar:ByteArray):void
        {
            award_get = ar.readInt();
        }
    }
}
