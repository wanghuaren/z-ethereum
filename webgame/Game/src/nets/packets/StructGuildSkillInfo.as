package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *工会技能研发信息
    */
    public class StructGuildSkillInfo implements ISerializable
    {
        /** 
        *技能类型
        */
        public var skillId:int;
        /** 
        *技能等级
        */
        public var level:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(skillId);
            ar.writeInt(level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            skillId = ar.readInt();
            level = ar.readInt();
        }
    }
}
