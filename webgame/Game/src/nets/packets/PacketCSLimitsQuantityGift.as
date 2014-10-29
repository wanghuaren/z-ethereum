package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *领取限量礼包
    */
    public class PacketCSLimitsQuantityGift implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38913;
        /** 
        *物品ID
        */
        public var itemid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(itemid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemid = ar.readInt();
        }
    }
}
