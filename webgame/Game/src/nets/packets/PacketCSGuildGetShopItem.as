package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *购买个人商店物品
    */
    public class PacketCSGuildGetShopItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39269;
        /** 
        *道具编号
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
