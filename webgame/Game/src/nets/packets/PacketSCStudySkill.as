package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSkillItem2
    /** 
    *学习技能
    */
    public class PacketSCStudySkill implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8702;
        /** 
        *技能
        */
        public var skillitem:StructSkillItem2 = new StructSkillItem2();
        /** 
        *结果
        */
        public var tag:int;
        /** 
        *信息
        */
        public var msg:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            skillitem.Serialize(ar);
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 256);
        }
        public function Deserialize(ar:ByteArray):void
        {
            skillitem.Deserialize(ar);
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
