package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *更新今日个人赛比赛结果
    */
    public class PacketSCGetNowSHUpdate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53008;
        /** 
        *胜利场次
        */
        public var win:int;
        /** 
        *失败场次
        */
        public var lost:int;
        /** 
        *最大连胜次数
        */
        public var winmax:int;
        /** 
        *目前积分
        */
        public var coin:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(win);
            ar.writeInt(lost);
            ar.writeInt(winmax);
            ar.writeInt(coin);
        }
        public function Deserialize(ar:ByteArray):void
        {
            win = ar.readInt();
            lost = ar.readInt();
            winmax = ar.readInt();
            coin = ar.readInt();
        }
    }
}
