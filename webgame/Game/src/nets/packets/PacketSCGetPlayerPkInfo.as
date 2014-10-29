package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得玩家pk信息返回
    */
    public class PacketSCGetPlayerPkInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20047;
        /** 
        *实力排名
        */
        public var no:int;
        /** 
        *当前连胜
        */
        public var c_win:int;
        /** 
        *实力积分
        */
        public var rank:int;
        /** 
        *最高连胜
        */
        public var max_win:int;
        /** 
        *获得声望
        */
        public var renown:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(no);
            ar.writeInt(c_win);
            ar.writeInt(rank);
            ar.writeInt(max_win);
            ar.writeInt(renown);
        }
        public function Deserialize(ar:ByteArray):void
        {
            no = ar.readInt();
            c_win = ar.readInt();
            rank = ar.readInt();
            max_win = ar.readInt();
            renown = ar.readInt();
        }
    }
}
