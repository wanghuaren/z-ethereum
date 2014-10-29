package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *获得物品的LOG
    */
    public class StructHeroGetItemLog implements ISerializable
    {
        /** 
        *物品类型ID
        */
        public var ItemId:int;
        /** 
        *物品数量
        */
        public var ItemNum:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(ItemId);
            ar.writeInt(ItemNum);
        }
        public function Deserialize(ar:ByteArray):void
        {
            ItemId = ar.readInt();
            ItemNum = ar.readInt();
        }
    }
}
