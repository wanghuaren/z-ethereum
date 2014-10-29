package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *领取QQ黄钻礼包
    */
    public class PacketCSQQYellowGift implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38903;
        /** 
        *类型 1新手礼包 2:普通黄钻每日 3:年费黄钻每日 4:3366用户每日登录礼包
        */
        public var type:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
        }
    }
}
