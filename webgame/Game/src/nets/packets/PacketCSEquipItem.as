package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *穿装备
    */
    public class PacketCSEquipItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8009;
        /** 
        *源位置
        */
        public var srcindex:int;
        /** 
        *装备位置：默认传0 ，有位置传位置
        */
        public var equip_pos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(srcindex);
            ar.writeInt(equip_pos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            srcindex = ar.readInt();
            equip_pos = ar.readInt();
        }
    }
}
