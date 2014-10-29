package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *获得物品的LOG
    */
    public class StructGetItemLog implements ISerializable
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
        *角色名称
        */
        public var PlayerName:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(ItemId);
            ar.writeInt(ItemNum);
            PacketFactory.Instance.WriteString(ar, PlayerName, 32);
        }
        public function Deserialize(ar:ByteArray):void
        {
            ItemId = ar.readInt();
            ItemNum = ar.readInt();
            var PlayerNameLength:int = ar.readInt();
            PlayerName = ar.readMultiByte(PlayerNameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
