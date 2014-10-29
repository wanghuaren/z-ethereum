package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildSkillList2
    /** 
    *家族角色数据
    */
    public class StructGuildPlayerData implements ISerializable
    {
        /** 
        *家族技能状态
        */
        public var skillstate:StructGuildSkillList2 = new StructGuildSkillList2();
        /** 
        *职位
        */
        public var job:int;
        /** 
        *家族名称
        */
        public var guildname:String = new String();
        /** 
        *贡献
        */
        public var contribute:int;
        /** 
        *威望
        */
        public var cachet:int;
        /** 
        *上个家族id
        */
        public var prevguildid:int;
        /** 
        *上个家族离开时间
        */
        public var leavetime:int;

        public function Serialize(ar:ByteArray):void
        {
            skillstate.Serialize(ar);
            ar.writeInt(job);
            PacketFactory.Instance.WriteString(ar, guildname, 64);
            ar.writeInt(contribute);
            ar.writeInt(cachet);
            ar.writeInt(prevguildid);
            ar.writeInt(leavetime);
        }
        public function Deserialize(ar:ByteArray):void
        {
            skillstate.Deserialize(ar);
            job = ar.readInt();
            var guildnameLength:int = ar.readInt();
            guildname = ar.readMultiByte(guildnameLength,PacketFactory.Instance.GetCharSet());
            contribute = ar.readInt();
            cachet = ar.readInt();
            prevguildid = ar.readInt();
            leavetime = ar.readInt();
        }
    }
}
