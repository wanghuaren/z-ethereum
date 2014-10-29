package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取QQ邀请奖励
    */
    public class PacketCSInviteQQGift implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38917;
        /** 
        *第几个邀请礼包
        */
        public var index:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(index);
        }
        public function Deserialize(ar:ByteArray):void
        {
            index = ar.readInt();
        }
    }
}
