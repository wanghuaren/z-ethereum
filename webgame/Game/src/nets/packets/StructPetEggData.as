package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructSimpleLogInfo2
    /** 
    *宠物蛋信息
    */
    public class StructPetEggData implements ISerializable
    {
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
        *id
        */
        public var petid:int;
        /** 
        *战力
        */
        public var fightvalue:int;
        /** 
        *等级
        */
        public var level:int;
        /** 
        *经验
        */
        public var exp:Number;
        /** 
        *技能列表
        */
        public var arrItemskill:Vector.<int> = new Vector.<int>();
        /** 
        *实例数据
        */
        public var loginfo:StructSimpleLogInfo2 = new StructSimpleLogInfo2();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(itempos);
            ar.writeInt(itemType);
            ar.writeShort(itemRuler);
            ar.writeByte(bindValue);
            ar.writeInt(existtime);
            ar.writeInt(petid);
            ar.writeInt(fightvalue);
            ar.writeByte(level);
            ar.writeDouble(exp);
            ar.writeInt(arrItemskill.length);
            for each (var skillitem:int in arrItemskill)
            {
                ar.writeInt(skillitem);
            }
            loginfo.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itempos = ar.readInt();
            itemType = ar.readInt();
            itemRuler = ar.readShort();
            bindValue = ar.readByte();
            existtime = ar.readInt();
            petid = ar.readInt();
            fightvalue = ar.readInt();
            level = ar.readByte();
            exp = ar.readDouble();
            arrItemskill= new  Vector.<int>();
            var skillLength:int = ar.readInt();
            for (var iskill:int=0;iskill<skillLength; ++iskill)
            {
                arrItemskill.push(ar.readInt());
            }
            loginfo.Deserialize(ar);
        }
    }
}
