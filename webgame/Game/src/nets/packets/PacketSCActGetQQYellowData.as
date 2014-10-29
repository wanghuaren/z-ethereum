package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取QQ黄钻续费活动信息数据返回
    */
    public class PacketSCActGetQQYellowData implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38132;
        /** 
        *奖券数量
        */
        public var num:int;
        /** 
        *礼包的抽取状态，从低位到高位，为1表示已抽取，为0表示未抽取
        */
        public var state:int;
        /** 
        *当前可放入背包的礼包编号
        */
        public var last_prize_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(num);
            ar.writeInt(state);
            ar.writeInt(last_prize_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            num = ar.readInt();
            state = ar.readInt();
            last_prize_id = ar.readInt();
        }
    }
}
