package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取礼包
    */
    public class PacketCSGetGift implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31005;
        /** 
        *玩家VIP等级
        */
        public var viplevel:int;
        /** 
        *扩展礼包1:领取0:不领取
        */
        public var extend:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(viplevel);
            ar.writeInt(extend);
        }
        public function Deserialize(ar:ByteArray):void
        {
            viplevel = ar.readInt();
            extend = ar.readInt();
        }
    }
}
