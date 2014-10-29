package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *装配坐骑技能
    */
    public class PacketCSEquipHoreseSkill implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 16018;
        /** 
        *技能id
        */
        public var itemid:int;
        /** 
        *技能位置 1 开始
        */
        public var skillpos:int;
        /** 
        *坐骑位置
        */
        public var horsepos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(itemid);
            ar.writeInt(skillpos);
            ar.writeInt(horsepos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemid = ar.readInt();
            skillpos = ar.readInt();
            horsepos = ar.readInt();
        }
    }
}
