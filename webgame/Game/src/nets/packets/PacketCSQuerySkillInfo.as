package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *查询技能信息
    */
    public class PacketCSQuerySkillInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8707;
        /** 
        *技能ID
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
