package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *星魂信息
    */
    public class StructStarItemData implements ISerializable
    {
        /** 
        *物品位置
        */
        public var itempos:int;
        /** 
        *物品类型
        */
        public var itemType:int;
        /** 
        *物品规则
        */
        public var itemRuler:int;
        /** 
        *绑定
        */
        public var bindValue:int;
        /** 
        *过期时间
        */
        public var existtime:int;
        /** 
        *当前数量
        */
        public var itemCount:int;
        /** 
        *能量
        */
        public var energy:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(itempos);
            ar.writeInt(itemType);
            ar.writeShort(itemRuler);
            ar.writeByte(bindValue);
            ar.writeInt(existtime);
            ar.writeInt(itemCount);
            ar.writeInt(energy);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itempos = ar.readInt();
            itemType = ar.readInt();
            itemRuler = ar.readShort();
            bindValue = ar.readByte();
            existtime = ar.readInt();
            itemCount = ar.readInt();
            energy = ar.readInt();
        }
    }
}
