package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *召唤家族BOSS
    */
    public class PacketCSCallGuildBoss implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39424;
        /** 
        *召唤的BOSS等级
        */
        public var boss_level:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(boss_level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            boss_level = ar.readInt();
        }
    }
}
