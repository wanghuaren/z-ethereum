package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *伙伴装备
    */
    public class StructPetEquipItem implements ISerializable
    {
        /** 
        *装备编号
        */
        public var itemid:int;
        /** 
        *装备位置
        */
        public var Equippos:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(itemid);
            ar.writeInt(Equippos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemid = ar.readInt();
            Equippos = ar.readInt();
        }
    }
}
