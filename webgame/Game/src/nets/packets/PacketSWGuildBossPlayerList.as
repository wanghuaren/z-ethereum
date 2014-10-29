package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructGuildBossPlayerList2
    /** 
    *家族boss伤害列表(从高到低排序)
    */
    public class PacketSWGuildBossPlayerList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 51400;
        /** 
        *家族id
        */
        public var guildid:int;
        /** 
        *boss等级
        */
        public var bosslevel:int;
        /** 
        *玩家信息
        */
        public var playerlist:StructGuildBossPlayerList2 = new StructGuildBossPlayerList2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(guildid);
            ar.writeInt(bosslevel);
            playerlist.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            guildid = ar.readInt();
            bosslevel = ar.readInt();
            playerlist.Deserialize(ar);
        }
    }
}
