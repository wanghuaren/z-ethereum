package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *购买家族珍宝
    */
    public class PacketCSBuyGuildItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39417;
        /** 
        *购买的珍宝物品
        */
        public var itemid:int;
        /** 
        *购买家族珍宝数量
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
