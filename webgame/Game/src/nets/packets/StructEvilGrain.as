package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *魔纹信息
    */
    public class StructEvilGrain implements ISerializable
    {
        /** 
        *是否开启 0:未开启 1:已开启(普通孔) 2:已开启(多彩孔)
        */
        public var IsOpen:int;
        /** 
        *物品规则
        */
        public var itemRuler:int;
        /** 
        *魔纹id
        */
        public var toolId:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeByte(IsOpen);
            ar.writeShort(itemRuler);
            ar.writeInt(toolId);
        }
        public function Deserialize(ar:ByteArray):void
        {
            IsOpen = ar.readByte();
            itemRuler = ar.readShort();
            toolId = ar.readInt();
        }
    }
}
