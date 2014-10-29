package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructMonsterInfo2
    /** 
    *怪物进入视野
    */
    public class PacketSCMonsterEnterGrid implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 1008;
        /** 
        *怪物信息
        */
        public var monsterinfo:StructMonsterInfo2 = new StructMonsterInfo2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            monsterinfo.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            monsterinfo.Deserialize(ar);
        }
    }
}
