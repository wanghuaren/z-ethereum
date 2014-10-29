package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *活跃点奖励信息
    */
    public class StructActivityPrizeInfo implements ISerializable
    {
        /** 
        *是否领取 0未领取 1领取
        */
        public var isget:int;
        /** 
        *等级编号 开始为1
        */
        public var numid:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(isget);
            ar.writeInt(numid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            isget = ar.readInt();
            numid = ar.readInt();
        }
    }
}
