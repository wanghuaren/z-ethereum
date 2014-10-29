package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得个人赛比赛奖励信息返回
    */
    public class PacketSCGetSHPrizeInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53028;
        /** 
        *每日参与奖励，bit位n标识第n个奖励状态(n从1开始)（1~9）， 0 未领取，1 已领取
        */
        public var prize:int;
        /** 
        *今天胜利场数
        */
        public var today_win:int;
        /** 
        *今天参战场数
        */
        public var today_join:int;
        /** 
        *本周参战次数
        */
        public var cur_week_join:int;
        /** 
        *本周胜利次数
        */
        public var cur_week_win:int;
        /** 
        *上周排名
        */
        public var last_week_no:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(prize);
            ar.writeInt(today_win);
            ar.writeInt(today_join);
            ar.writeInt(cur_week_join);
            ar.writeInt(cur_week_win);
            ar.writeInt(last_week_no);
        }
        public function Deserialize(ar:ByteArray):void
        {
            prize = ar.readInt();
            today_win = ar.readInt();
            today_join = ar.readInt();
            cur_week_join = ar.readInt();
            cur_week_win = ar.readInt();
            last_week_no = ar.readInt();
        }
    }
}
