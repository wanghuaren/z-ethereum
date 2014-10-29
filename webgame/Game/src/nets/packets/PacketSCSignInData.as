package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *签到数据
    */
    public class PacketSCSignInData implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 37000;
        /** 
        *签到
        */
        public var sign:int;
        /** 
        *补签
        */
        public var patch:int;
        /** 
        *剩余免费补签次数
        */
        public var freepatchtimes:int;
        /** 
        *今天是第几天
        */
        public var dayIndex:int;
        /** 
        *连续签到次数
        */
        public var continuetimes:int;
        /** 
        *累计签到次数
        */
        public var totalsigntimes:int;
        /** 
        *免费抽奖次数
        */
        public var alltimes:int;
        /** 
        *已抽奖次数
        */
        public var times:int;
        /** 
        *累积奖励状态
        */
        public var accumulatestate:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(sign);
            ar.writeInt(patch);
            ar.writeInt(freepatchtimes);
            ar.writeInt(dayIndex);
            ar.writeInt(continuetimes);
            ar.writeInt(totalsigntimes);
            ar.writeInt(alltimes);
            ar.writeInt(times);
            ar.writeInt(accumulatestate);
        }
        public function Deserialize(ar:ByteArray):void
        {
            sign = ar.readInt();
            patch = ar.readInt();
            freepatchtimes = ar.readInt();
            dayIndex = ar.readInt();
            continuetimes = ar.readInt();
            totalsigntimes = ar.readInt();
            alltimes = ar.readInt();
            times = ar.readInt();
            accumulatestate = ar.readInt();
        }
    }
}
