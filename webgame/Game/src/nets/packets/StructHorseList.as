package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *坐骑列表
    */
    public class StructHorseList implements ISerializable
    {
        /** 
        *坐骑ID
        */
        public var horseid:int;
        /** 
        *位置
        */
        public var pos:int;
        /** 
        *状态
        */
        public var state:int;
        /** 
        *战力值
        */
        public var fight_value:int;
        /** 
        *坐骑五行
        */
        public var horse_root:int;
        /** 
        *过期时间
        */
        public var exist_time:int;
        /** 
        *技能开启情况
        */
        public var skill_open:int;
        /** 
        *强化等级
        */
        public var strong_level:int;
        /** 
        *技能列表
        */
        public var arrItemskill_l:Vector.<int> = new Vector.<int>();
        /** 
        *时装编号
        */
        public var fachion_id:int;
        /** 
        *当前形象
        */
        public var skin_level:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(horseid);
            ar.writeInt(pos);
            ar.writeInt(state);
            ar.writeInt(fight_value);
            ar.writeInt(horse_root);
            ar.writeInt(exist_time);
            ar.writeInt(skill_open);
            ar.writeInt(strong_level);
            ar.writeInt(arrItemskill_l.length);
            for each (var skill_litem:int in arrItemskill_l)
            {
                ar.writeInt(skill_litem);
            }
            ar.writeInt(fachion_id);
            ar.writeInt(skin_level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            horseid = ar.readInt();
            pos = ar.readInt();
            state = ar.readInt();
            fight_value = ar.readInt();
            horse_root = ar.readInt();
            exist_time = ar.readInt();
            skill_open = ar.readInt();
            strong_level = ar.readInt();
            arrItemskill_l= new  Vector.<int>();
            var skill_lLength:int = ar.readInt();
            for (var iskill_l:int=0;iskill_l<skill_lLength; ++iskill_l)
            {
                arrItemskill_l.push(ar.readInt());
            }
            fachion_id = ar.readInt();
            skin_level = ar.readInt();
        }
    }
}
