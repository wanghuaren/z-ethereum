package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *装备信息
    */
    public class StructEquipInfo implements ISerializable
    {
        /** 
        *物品ID
        */
        public var itemid:int;
        /** 
        *物品位置
        */
        public var pos:int;
        /** 
        *物品等级
        */
        public var level:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(itemid);
            ar.writeInt(pos);
            ar.writeInt(level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemid = ar.readInt();
            pos = ar.readInt();
            level = ar.readInt();
        }
    }
}
