package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *有使用次数的物品信息
    */
    public class StructTimesItemData implements ISerializable
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
        *剩余使用次数
        */
        public var times:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(itempos);
            ar.writeInt(itemType);
            ar.writeShort(itemRuler);
            ar.writeByte(bindValue);
            ar.writeInt(existtime);
            ar.writeInt(itemCount);
            ar.writeInt(times);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itempos = ar.readInt();
            itemType = ar.readInt();
            itemRuler = ar.readShort();
            bindValue = ar.readByte();
            existtime = ar.readInt();
            itemCount = ar.readInt();
            times = ar.readInt();
        }
    }
}
