package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家卡片数据
    */
    public class StructCardData implements ISerializable
    {
        /** 
        *卡片id
        */
        public var card_id:int;
        /** 
        *卡片等级
        */
        public var level:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(card_id);
            ar.writeInt(level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            card_id = ar.readInt();
            level = ar.readInt();
        }
    }
}
