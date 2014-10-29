package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *神秘商店物品
    */
    public class StructRmbShopItem implements ISerializable
    {
        /** 
        *物品
        */
        public var item:int;
        /** 
        *数量0:已买过
        */
        public var num:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(item);
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            item = ar.readInt();
            num = ar.readInt();
        }
    }
}
