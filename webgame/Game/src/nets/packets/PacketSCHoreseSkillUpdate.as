package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *坐骑技能更新
    */
    public class PacketSCHoreseSkillUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 16024;
        /** 
        *技能id
        */
        public var skill:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(skill);
        }
        public function Deserialize(ar:ByteArray):void
        {
            skill = ar.readInt();
        }
    }
}
