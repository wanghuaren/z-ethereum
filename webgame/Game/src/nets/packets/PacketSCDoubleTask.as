package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *双倍任务次数更新
    */
    public class PacketSCDoubleTask implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 40102;
        /** 
        *当日皇榜任务次数
        */
        public var AwardCurr:int;
        /** 
        *皇榜任务最大次数
        */
        public var AwardMax:int;
        /** 
        *当日帮派任务次数
        */
        public var GuildCurr:int;
        /** 
        *帮派任务最大次数
        */
        public var GuildMax:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(AwardCurr);
            ar.writeInt(AwardMax);
            ar.writeInt(GuildCurr);
            ar.writeInt(GuildMax);
        }
        public function Deserialize(ar:ByteArray):void
        {
            AwardCurr = ar.readInt();
            AwardMax = ar.readInt();
            GuildCurr = ar.readInt();
            GuildMax = ar.readInt();
        }
    }
}
