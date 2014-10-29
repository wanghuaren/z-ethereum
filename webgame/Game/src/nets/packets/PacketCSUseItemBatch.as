package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *批量使用物品
    */
    public class PacketCSUseItemBatch implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14038;
        /** 
        *物品id
        */
        public var itemid:int;
        /** 
        *物品数量
        */
        public var num:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(itemid);
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemid = ar.readInt();
            num = ar.readInt();
        }
    }
}
