package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSkillList2
    /** 
    *学习天赋技能
    */
    public class PacketCSStudyGeniusSkill implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8703;
        /** 
        *天赋技能数组
        */
        public var skillItemList:StructSkillList2 = new StructSkillList2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            skillItemList.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            skillItemList.Deserialize(ar);
        }
    }
}
