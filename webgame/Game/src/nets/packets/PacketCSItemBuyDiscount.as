package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *打折购买物品
    */
    public class PacketCSItemBuyDiscount implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 17007;
        /** 
        *物品id
        */
        public var itemid:int;
        /** 
        *数量
        */
        public var num:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(itemid);
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemid = ar.readInt();
            num = ar.readInt();
        }
    }
}
