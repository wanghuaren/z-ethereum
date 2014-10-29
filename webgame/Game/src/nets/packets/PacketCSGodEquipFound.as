package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *神器铸造
    */
    public class PacketCSGodEquipFound implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15027;
        /** 
        *损坏的神器id
        */
        public var ItemId:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(ItemId);
        }
        public function Deserialize(ar:ByteArray):void
        {
            ItemId = ar.readInt();
        }
    }
}
