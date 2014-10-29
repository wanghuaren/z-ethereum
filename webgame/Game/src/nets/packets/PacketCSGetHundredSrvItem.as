package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *百服活动数据物品领取/购买
    */
    public class PacketCSGetHundredSrvItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53804;
        /** 
        *类型，1：百服庆典，2：百服皇城争霸(index1~6装备，7元宝)，3：集字兑奖
        */
        public var type:int;
        /** 
        *物品序号,下标从1开始
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
