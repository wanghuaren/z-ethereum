package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *研发家族技能
    */
    public class PacketCSActiveGuildSkill implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39411;
        /** 
        *研发的技能
        */
        public var skillid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(skillid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            skillid = ar.readInt();
        }
    }
}
