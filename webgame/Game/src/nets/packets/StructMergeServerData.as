package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *合服活动数据状态
    */
    public class StructMergeServerData implements ISerializable
    {
        /** 
        *合服时间YYYYMMDD
        */
        public var mergedate:int;
        /** 
        *神秘商店刷新序号，每次加一，每天6次，共5天
        */
        public var refresh_index:int;
        /** 
        *神秘商店物品购买状态，bit 位， 0 未购买， 1 已购买
        */
        public var action1_buylog:int;
        /** 
        *合服超值礼包物品购买状态，bit 位， 0 未购买， 1 已购买
        */
        public var action3_buylog:int;
        /** 
        *合服全民礼包物品购买状态，bit 位， 0 未购买， 1 已购买
        */
        public var action4_buylog:int;
        /** 
        *合服皇城争霸获胜状态，bit 位， 0~3 玩家是否获得活动霸主称号， 0 未获胜， 1 获胜
        */
        public var action5_winner:int;
        /** 
        *合服皇城争霸物品购买状态, 第一次占领取的物品编号
        */
        public var action5_buylog1:int;
        /** 
        *合服皇城争霸物品购买状态，第二次占领取的物品编号
        */
        public var action5_buylog2:int;
        /** 
        *合服皇城争霸物品购买状态，第四次占领取的物品编号
        */
        public var action5_buylog3:int;
        /** 
        *合服充值返利充值元宝数
        */
        public var action6_rmb:int;
        /** 
        *合服充值返利物品领取状态，bit 位， 0 未购买， 1 已购买
        */
        public var action6_buylog:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(mergedate);
            ar.writeInt(refresh_index);
            ar.writeInt(action1_buylog);
            ar.writeInt(action3_buylog);
            ar.writeInt(action4_buylog);
            ar.writeInt(action5_winner);
            ar.writeInt(action5_buylog1);
            ar.writeInt(action5_buylog2);
            ar.writeInt(action5_buylog3);
            ar.writeInt(action6_rmb);
            ar.writeInt(action6_buylog);
        }
        public function Deserialize(ar:ByteArray):void
        {
            mergedate = ar.readInt();
            refresh_index = ar.readInt();
            action1_buylog = ar.readInt();
            action3_buylog = ar.readInt();
            action4_buylog = ar.readInt();
            action5_winner = ar.readInt();
            action5_buylog1 = ar.readInt();
            action5_buylog2 = ar.readInt();
            action5_buylog3 = ar.readInt();
            action6_rmb = ar.readInt();
            action6_buylog = ar.readInt();
        }
    }
}
