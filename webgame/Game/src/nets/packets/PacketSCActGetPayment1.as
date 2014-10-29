package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取充值活动1信息返回
    */
    public class PacketSCActGetPayment1 implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38114;
        /** 
        *充值活动1状态，0表示未开启，否则表示第几阶段
        */
        public var state:int;
        /** 
        *奖励可领取状态，从低位到高位，代表第几个阶段可否领取
        */
        public var prizestate:int;
        /** 
        *奖励已领取状态，从低位到高位，代表第几个阶段是否已领取
        */
        public var getstate:int;
        /** 
        *已充值数量
        */
        public var num:int;
        /** 
        *开服时间
        */
        public var startdate:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(state);
            ar.writeInt(prizestate);
            ar.writeInt(getstate);
            ar.writeInt(num);
            ar.writeInt(startdate);
        }
        public function Deserialize(ar:ByteArray):void
        {
            state = ar.readInt();
            prizestate = ar.readInt();
            getstate = ar.readInt();
            num = ar.readInt();
            startdate = ar.readInt();
        }
    }
}
