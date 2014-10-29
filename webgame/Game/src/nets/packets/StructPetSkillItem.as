package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *宠物技能数据
    */
    public class StructPetSkillItem implements ISerializable
    {
        /** 
        *拥有的技能ID
        */
        public var skillId:int;
        /** 
        *技能等级
        */
        public var skillLevel:int;
        /** 
        *技能熟练度
        */
        public var skillExp:int;
        /** 
        *技能索引
        */
        public var skillpos:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(skillId);
            ar.writeInt(skillLevel);
            ar.writeInt(skillExp);
            ar.writeInt(skillpos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            skillId = ar.readInt();
            skillLevel = ar.readInt();
            skillExp = ar.readInt();
            skillpos = ar.readInt();
        }
    }
}
