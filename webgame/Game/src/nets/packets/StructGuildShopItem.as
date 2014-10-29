package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *帮派商店
    */
    public class StructGuildShopItem implements ISerializable
    {
        /** 
        *道具编号
        */
        public var itemid:int;
        /** 
        *已经兑换次数
        */
        public var times:int;
        /** 
        *需要贡献值
        */
        public var contribute:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(itemid);
            ar.writeInt(times);
            ar.writeInt(contribute);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemid = ar.readInt();
            times = ar.readInt();
            contribute = ar.readInt();
        }
    }
}
