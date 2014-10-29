package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得已经学会坐骑技能列表
    */
    public class PacketCSGetHoreseSkill implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 16022;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
        }
        public function Deserialize(ar:ByteArray):void
        {
        }
    }
}
