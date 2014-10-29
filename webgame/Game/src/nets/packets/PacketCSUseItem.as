package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *使用物品
    */
    public class PacketCSUseItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14012;
        /** 
        *物品在背包中的位置
        */
        public var bagindex:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(bagindex);
        }
        public function Deserialize(ar:ByteArray):void
        {
            bagindex = ar.readInt();
        }
    }
}
