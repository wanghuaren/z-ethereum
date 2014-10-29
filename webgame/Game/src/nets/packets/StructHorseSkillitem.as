package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *人物坐骑技能数据
    */
    public class StructHorseSkillitem implements ISerializable
    {
        /** 
        *拥有的技能ID
        */
        public var skillid:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(skillid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            skillid = ar.readInt();
        }
    }
}
