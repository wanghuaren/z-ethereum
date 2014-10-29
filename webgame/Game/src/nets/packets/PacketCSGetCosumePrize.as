package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *领取消费返利奖励
    */
    public class PacketCSGetCosumePrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38102;
        /** 
        *奖励序号
        */
        public var index:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(index);
        }
        public function Deserialize(ar:ByteArray):void
        {
            index = ar.readInt();
        }
    }
}
