package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *新手卡奖励道具信息
    */
    public class StructCDKeyItem implements ISerializable
    {
        /** 
        *道具编号
        */
        public var ItemId:int;
        /** 
        *数量
        */
        public var ItemNum:int;
        /** 
        *绑定规则
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
