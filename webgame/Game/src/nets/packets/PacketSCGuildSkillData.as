package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildSkillList2
    /** 
    *请求个人家族技能信息
    */
    public class PacketSCGuildSkillData implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39410;
        /** 
        *技能信息
        */
        public var skilllist:StructGuildSkillList2 = new StructGuildSkillList2();
        /** 
        *家族贡献
        */
        public var contribute:int;
        /** 
        *家族威望
        */
        public var cachet:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            skilllist.Serialize(ar);
            ar.writeInt(contribute);
            ar.writeInt(cachet);
        }
        public function Deserialize(ar:ByteArray):void
        {
            skilllist.Deserialize(ar);
            contribute = ar.readInt();
            cachet = ar.readInt();
        }
    }
}
