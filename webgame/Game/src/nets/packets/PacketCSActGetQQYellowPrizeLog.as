package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *QQ黄钻续费礼包领取日志
    */
    public class PacketCSActGetQQYellowPrizeLog implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38137;

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
