package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *秘商店销售记录
    */
    public class StructRmbShopSell implements ISerializable
    {
        /** 
        *名字
        */
        public var name:String = new String();
        /** 
        *物品
        */
        public var item:int;
        /** 
        *数量
        */
        public var num:int;

        public function Serialize(ar:ByteArray):void
        {
            PacketFactory.Instance.WriteString(ar, name, 64);
            ar.writeInt(item);
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            item = ar.readInt();
            num = ar.readInt();
        }
    }
}
