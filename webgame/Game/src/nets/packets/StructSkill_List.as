package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSkillItem2
    /** 
    *技能列表
    */
    public class StructSkill_List implements ISerializable
    {
        /** 
        *技能数据
        */
        public var arrItemskill_list:Vector.<StructSkillItem2> = new Vector.<StructSkillItem2>();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(arrItemskill_list.length);
            for each (var skill_listitem:Object in arrItemskill_list)
            {
                var objskill_list:ISerializable = skill_listitem as ISerializable;
                if (null!=objskill_list)
                {
                    objskill_list.Serialize(ar);
                }
            }
        }
        public function Deserialize(ar:ByteArray):void
        {
            arrItemskill_list= new  Vector.<StructSkillItem2>();
            var skill_listLength:int = ar.readInt();
            for (var iskill_list:int=0;iskill_list<skill_listLength; ++iskill_list)
            {
                var objSkillItem:StructSkillItem2 = new StructSkillItem2();
                objSkillItem.Deserialize(ar);
                arrItemskill_list.push(objSkillItem);
            }
        }
    }
}
