package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *宝石信息
    */
    public class StructGemInfo implements ISerializable
    {
        /** 
        *物品规则
        */
        public var itemRuler:int;
        /** 
        *宝石id
        */
        public var toolId:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeShort(itemRuler);
            ar.writeInt(toolId);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemRuler = ar.readShort();
            toolId = ar.readInt();
        }
    }
}
