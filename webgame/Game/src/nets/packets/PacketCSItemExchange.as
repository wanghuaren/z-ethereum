package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *物品换购
    */
    public class PacketCSItemExchange implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 17005;
        /** 
        *商店id
        */
        public var shopid:int;
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
            ar.writeInt(shopid);
            ar.writeInt(itemid);
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            shopid = ar.readInt();
            itemid = ar.readInt();
            num = ar.readInt();
        }
    }
}
