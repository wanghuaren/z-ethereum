package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取QQ黄钻等级礼包领取状态
    */
    public class PacketCSQQYellowLevelGiftState implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38907;

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
