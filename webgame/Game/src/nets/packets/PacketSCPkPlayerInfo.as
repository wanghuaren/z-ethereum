package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家pk状态信息
    */
    public class PacketSCPkPlayerInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20074;
        /** 
        *玩家1 血量百分比
        */
        public var player1:int;
        /** 
        *玩家1伙伴 血量百分比
        */
        public var playerpet1:int;
        /** 
        *玩家2 血量百分比
        */
        public var player2:int;
        /** 
        *玩家2伙伴 血量百分比
        */
        public var playerpet2:int;
        /** 
        *剩余时间
        */
        public var last_time:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(player1);
            ar.writeInt(playerpet1);
            ar.writeInt(player2);
            ar.writeInt(playerpet2);
            ar.writeInt(last_time);
        }
        public function Deserialize(ar:ByteArray):void
        {
            player1 = ar.readInt();
            playerpet1 = ar.readInt();
            player2 = ar.readInt();
            playerpet2 = ar.readInt();
            last_time = ar.readInt();
        }
    }
}
