package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *狂欢活动数据状态
    */
    public class StructWorldCupData implements ISerializable
    {
        /** 
        *狂欢庆典物品领取状态，bit位(下标从1开始)， 0 未领取， 1 已领取
        */
        public var action1_log:int;
        /** 
        *暂时不用，狂欢皇城争霸第一次获胜物品领取状态(1~6道具, 7 元宝，8 是否可以领取)，bit 位， 0 未领取， 1 已领取
        */
        public var action2_log1:int;
        /** 
        *暂时不用，狂欢皇城争霸第二次获胜物品领取状态(1~6道具, 7 元宝，8 是否可以领取)，bit 位， 0 未领取， 1 已领取
        */
        public var action2_log2:int;
        /** 
        *暂时不用，狂欢皇城争霸第三次获胜物品领取状态(1~6道具, 7 元宝，8 是否可以领取)，bit 位， 0 未领取， 1 已领取
        */
        public var action2_log3:int;
        /** 
        *狂欢集字兑奖，bit位(下标从1开始)， 0 未兑奖， 1 已兑奖
        */
        public var action3_log:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(action1_log);
            ar.writeInt(action2_log1);
            ar.writeInt(action2_log2);
            ar.writeInt(action2_log3);
            ar.writeInt(action3_log);
        }
        public function Deserialize(ar:ByteArray):void
        {
            action1_log = ar.readInt();
            action2_log1 = ar.readInt();
            action2_log2 = ar.readInt();
            action2_log3 = ar.readInt();
            action3_log = ar.readInt();
        }
    }
}
