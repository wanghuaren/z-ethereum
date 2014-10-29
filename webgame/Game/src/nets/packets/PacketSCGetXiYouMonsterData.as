package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取西游降魔信息数据返回
    */
    public class PacketSCGetXiYouMonsterData implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38124;
        /** 
        *当前已降魔序号
        */
        public var num:int;
        /** 
        *宝箱已领取状态
        */
        public var prize_state:int;
        /** 
        *终极妖怪的可降服次数
        */
        public var last_times:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(num);
            ar.writeInt(prize_state);
            ar.writeInt(last_times);
        }
        public function Deserialize(ar:ByteArray):void
        {
            num = ar.readInt();
            prize_state = ar.readInt();
            last_times = ar.readInt();
        }
    }
}
