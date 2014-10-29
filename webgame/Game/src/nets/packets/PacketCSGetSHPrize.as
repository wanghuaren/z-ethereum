package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得个人赛比赛奖励
    */
    public class PacketCSGetSHPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53029;
        /** 
        *1 每日参与 2 挑战成就 3 每周排名
        */
        public var type:int;
        /** 
        *领取第几个奖励(1~3)
        */
        public var index:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            ar.writeInt(index);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            index = ar.readInt();
        }
    }
}
