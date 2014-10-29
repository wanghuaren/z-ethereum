package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *工会珍宝研发信息
    */
    public class StructGuildItemInfo implements ISerializable
    {
        /** 
        *珍宝类型
        */
        public var itemType:int;
        /** 
        *珍宝等级
        */
        public var level:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(itemType);
            ar.writeInt(level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemType = ar.readInt();
            level = ar.readInt();
        }
    }
}
