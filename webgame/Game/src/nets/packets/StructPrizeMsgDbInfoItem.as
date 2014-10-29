package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *物品信息
    */
    public class StructPrizeMsgDbInfoItem implements ISerializable
    {
        /** 
        *物品类型ID
        */
        public var ItemId:int;
        /** 
        *物品数量
        */
        public var ItemNum:int;
        /** 
        *物品规则
        */
        public var ItemRuler:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(ItemId);
            ar.writeInt(ItemNum);
            ar.writeInt(ItemRuler);
        }
        public function Deserialize(ar:ByteArray):void
        {
            ItemId = ar.readInt();
            ItemNum = ar.readInt();
            ItemRuler = ar.readInt();
        }
    }
}
