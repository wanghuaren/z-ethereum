package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *等级QQ币奖励兑换元宝
    */
    public class PacketCSLevelQQGiftToRmb implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38911;

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
