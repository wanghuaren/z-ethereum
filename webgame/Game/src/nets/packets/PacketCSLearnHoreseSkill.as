package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *学习坐骑技能
    */
    public class PacketCSLearnHoreseSkill implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 16016;
        /** 
        *技能书id
        */
        public var itemid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(itemid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemid = ar.readInt();
        }
    }
}
