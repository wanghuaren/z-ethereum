package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *一键穿装备
    */
    public class PacketCSEquipAll implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8026;
        /** 
        *0玩家 1第一个伙伴2，3。。。
        */
        public var pos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readInt();
        }
    }
}
