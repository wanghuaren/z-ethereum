package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *掉落列表
    */
    public class StructDropList implements ISerializable
    {
        /** 
        *掉落物品索引
        */
        public var index:int;
        /** 
        *物品id,id为0时表示该物品为金币
        */
        public var itemid:int;
        /** 
        *物品数量
        */
        public var num:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(index);
            ar.writeInt(itemid);
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            index = ar.readInt();
            itemid = ar.readInt();
            num = ar.readInt();
        }
    }
}
