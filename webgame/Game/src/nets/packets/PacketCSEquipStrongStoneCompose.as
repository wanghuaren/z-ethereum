package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *装备强化石合成
    */
    public class PacketCSEquipStrongStoneCompose implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15022;
        /** 
        *强化石id
        */
        public var ItemId:int;
        /** 
        *合成数量
        */
        public var Count:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(ItemId);
            ar.writeInt(Count);
        }
        public function Deserialize(ar:ByteArray):void
        {
            ItemId = ar.readInt();
            Count = ar.readInt();
        }
    }
}
