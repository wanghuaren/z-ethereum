package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *修理
    */
    public class PacketCSEquipRepair implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15014;
        /** 
        *类型(0:角色，1:伙伴)
        */
        public var type:int;
        /** 
        *哪一个伙伴
        */
        public var pet:int;
        /** 
        *位置 0：表示所有
        */
        public var pos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            ar.writeInt(pet);
            ar.writeInt(pos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            pet = ar.readInt();
            pos = ar.readInt();
        }
    }
}
