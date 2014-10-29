package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructItemContainer2
    import netc.packets2.StructItemContainer2
    import netc.packets2.StructBournList2
    import netc.packets2.StructSkill_List2
    import netc.packets2.StructSimpleLogInfo2
    /** 
    *伙伴数据信息
    */
    public class StructPetDBInfo implements ISerializable
    {
        /** 
        *伙伴ID
        */
        public var petid:int;
        /** 
        *角色名字
        */
        public var name:String = new String();
        /** 
        *生命值
        */
        public var hp:int;
        /** 
        *魔法值
        */
        public var mp:int;
        /** 
        *等级
        */
        public var level:int;
        /** 
        *经验
        */
        public var exp:Number;
        /** 
        *阵营编号
        */
        public var camp_id:int;
        /** 
        *伙伴状态 招募 已招募 解雇
        */
        public var petState:int;
        /** 
        *4技能状态
        */
        public var skillstate:int;
        /** 
        *所在宠物栏位置
        */
        public var posofslot:int;
        /** 
        *战力值
        */
        public var gradevalue:int;
        /** 
        *星魂战力值
        */
        public var starvalue:int;
        /** 
        *是否出战 0没有出战 1 出战 2合体
        */
        public var isfight:int;
        /** 
        *身上装备
        */
        public var equipItem:StructItemContainer2 = new StructItemContainer2();
        /** 
        *星魂
        */
        public var starItem:StructItemContainer2 = new StructItemContainer2();
        /** 
        *境界
        */
        public var bourn:StructBournList2 = new StructBournList2();
        /** 
        *技能数据
        */
        public var skill_list:StructSkill_List2 = new StructSkill_List2();
        /** 
        *日志信息数据
        */
        public var loginfo:StructSimpleLogInfo2 = new StructSimpleLogInfo2();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(petid);
            PacketFactory.Instance.WriteString(ar, name, 32);
            ar.writeInt(hp);
            ar.writeInt(mp);
            ar.writeInt(level);
            ar.writeDouble(exp);
            ar.writeInt(camp_id);
            ar.writeInt(petState);
            ar.writeInt(skillstate);
            ar.writeInt(posofslot);
            ar.writeInt(gradevalue);
            ar.writeInt(starvalue);
            ar.writeInt(isfight);
            equipItem.Serialize(ar);
            starItem.Serialize(ar);
            bourn.Serialize(ar);
            skill_list.Serialize(ar);
            loginfo.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            petid = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            hp = ar.readInt();
            mp = ar.readInt();
            level = ar.readInt();
            exp = ar.readDouble();
            camp_id = ar.readInt();
            petState = ar.readInt();
            skillstate = ar.readInt();
            posofslot = ar.readInt();
            gradevalue = ar.readInt();
            starvalue = ar.readInt();
            isfight = ar.readInt();
            equipItem.Deserialize(ar);
            starItem.Deserialize(ar);
            bourn.Deserialize(ar);
            skill_list.Deserialize(ar);
            loginfo.Deserialize(ar);
        }
    }
}
