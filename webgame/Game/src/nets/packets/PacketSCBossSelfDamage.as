package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *boss活动自己数据刷新
    */
    public class PacketSCBossSelfDamage implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20036;
        /** 
        *自己的伤害
        */
        public var damage:int;
        /** 
        *自己伤害百分比
        */
        public var per:int;
        /** 
        *金币鼓舞次数
        */
        public var coinbuff:int;
        /** 
        *元宝鼓舞次数
        */
        public var rmbbuff:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(damage);
            ar.writeInt(per);
            ar.writeInt(coinbuff);
            ar.writeInt(rmbbuff);
        }
        public function Deserialize(ar:ByteArray):void
        {
            damage = ar.readInt();
            per = ar.readInt();
            coinbuff = ar.readInt();
            rmbbuff = ar.readInt();
        }
    }
}
