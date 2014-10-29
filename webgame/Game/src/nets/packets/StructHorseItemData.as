package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *非装备信息
    */
    public class StructHorseItemData implements ISerializable
    {
        /** 
        *强化等级
        */
        public var stronglevel:int;
        /** 
        *坐骑五行属性
        */
        public var horse_root:int;
        /** 
        *技能开启情况列表
        */
        public var skill_open:int;
        /** 
        *技能列表
        */
        public var arrItemskill_l:Vector.<int> = new Vector.<int>();
        /** 
        *物品位置
        */
        public var itempos:int;
        /** 
        *物品类型
        */
        public var itemType:int;
        /** 
        *物品规则
        */
        public var itemRuler:int;
        /** 
        *绑定
        */
        public var bindValue:int;
        /** 
        *过期时间
        */
        public var existtime:int;
        /** 
        *当前数量
        */
        public var itemCount:int;
        /** 
        *当前皮肤
        */
        public var skin_level:int;
        /** 
        *当前时装
        */
        public var fachion_id:int;
        /** 
        *当前时装
        */
        public var fachion_Rule:int;
        /** 
        *战力值
        */
        public var grade_value:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(stronglevel);
            ar.writeInt(horse_root);
            ar.writeInt(skill_open);
            ar.writeInt(arrItemskill_l.length);
            for each (var skill_litem:int in arrItemskill_l)
            {
                ar.writeInt(skill_litem);
            }
            ar.writeInt(itempos);
            ar.writeInt(itemType);
            ar.writeShort(itemRuler);
            ar.writeByte(bindValue);
            ar.writeInt(existtime);
            ar.writeInt(itemCount);
            ar.writeInt(skin_level);
            ar.writeInt(fachion_id);
            ar.writeInt(fachion_Rule);
            ar.writeInt(grade_value);
        }
        public function Deserialize(ar:ByteArray):void
        {
            stronglevel = ar.readInt();
            horse_root = ar.readInt();
            skill_open = ar.readInt();
            arrItemskill_l= new  Vector.<int>();
            var skill_lLength:int = ar.readInt();
            for (var iskill_l:int=0;iskill_l<skill_lLength; ++iskill_l)
            {
                arrItemskill_l.push(ar.readInt());
            }
            itempos = ar.readInt();
            itemType = ar.readInt();
            itemRuler = ar.readShort();
            bindValue = ar.readByte();
            existtime = ar.readInt();
            itemCount = ar.readInt();
            skin_level = ar.readInt();
            fachion_id = ar.readInt();
            fachion_Rule = ar.readInt();
            grade_value = ar.readInt();
        }
    }
}
