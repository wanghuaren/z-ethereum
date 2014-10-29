package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得是否有领取奖励信息
    */
    public class PacketCSHaveServerStartPrizeInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39750;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
        }
        public function Deserialize(ar:ByteArray):void
        {
        }
    }
}
