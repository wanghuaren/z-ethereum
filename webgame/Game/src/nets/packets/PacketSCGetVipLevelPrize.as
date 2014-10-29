package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *领取至尊VIP奖励返回
    */
    public class PacketSCGetVipLevelPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53605;
        /** 
        *格式XXNN， XX VIP等级， NN奖励序号
        */
        public var event_id:int;
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(event_id);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            event_id = ar.readInt();
            tag = ar.readInt();
        }
    }
}
