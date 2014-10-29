package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *每日奖励信息
    */
    public class StructDayPrizeInfo implements ISerializable
    {
        /** 
        *是否领取 0未领取 1领取
        */
        public var isget:int;
        /** 
        *限制id
        */
        public var limitid:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(isget);
            ar.writeInt(limitid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            isget = ar.readInt();
            limitid = ar.readInt();
        }
    }
}
