package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructDayPrizeInfo2
    /** 
    *推送每日奖励是否领取变化
    */
    public class PacketSCGetDayPrizeListInfoUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24210;
        /** 
        *每日领取列表
        */
        public var activityprizelist:StructDayPrizeInfo2 = new StructDayPrizeInfo2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            activityprizelist.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            activityprizelist.Deserialize(ar);
        }
    }
}
