package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructHorseSkillitem2
    /** 
    *人物坐骑技能数据
    */
    public class StructHorseSkillItem_l implements ISerializable
    {
        /** 
        *拥有的技能ID
        */
        public var arrItemskill_l:Vector.<StructHorseSkillitem2> = new Vector.<StructHorseSkillitem2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemskill_l.length);
            for each (var skill_litem:Object in arrItemskill_l)
            {
                var objskill_l:ISerializable = skill_litem as ISerializable;
                if (null!=objskill_l)
                {
                    objskill_l.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemskill_l= new  Vector.<StructHorseSkillitem2>();
            var skill_lLength:int = ar.readInt();
            for (var iskill_l:int=0;iskill_l<skill_lLength; ++iskill_l)
            {
                var objHorseSkillitem:StructHorseSkillitem2 = new StructHorseSkillitem2();
                objHorseSkillitem.Deserialize(ar);
                arrItemskill_l.push(objHorseSkillitem);
            }
        }
    }
}
