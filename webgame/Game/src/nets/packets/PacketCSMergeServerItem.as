package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *合服活动数据物品领取/购买
    */
    public class PacketCSMergeServerItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53704;
        /** 
        *类型，1：神秘商店，2：合服折扣商店，3：合服超值礼包，4：合服全民礼包，5：合服皇城争霸，6：合服充值返利
        */
        public var type:int;
        /** 
        *物品序号
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
