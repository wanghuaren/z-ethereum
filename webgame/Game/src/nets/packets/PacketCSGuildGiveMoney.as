package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *公会捐助
    */
    public class PacketCSGuildGiveMoney implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39218;
        /** 
        *游戏币
        */
        public var coin_1:int;
        /** 
        *元宝
        */
        public var coin_3:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(coin_1);
            ar.writeInt(coin_3);
        }
        public function Deserialize(ar:ByteArray):void
        {
            coin_1 = ar.readInt();
            coin_3 = ar.readInt();
        }
    }
}
