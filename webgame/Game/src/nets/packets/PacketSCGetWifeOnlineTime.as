package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得夫妻在线时间情况返回
    */
    public class PacketSCGetWifeOnlineTime implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54101;
        /** 
        *在线时间
        */
        public var online_time:int;
        /** 
        *当前是否可以领取 1 可领取 0 不能领取 2 今日无法领取
        */
        public var is_get:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(online_time);
            ar.writeInt(is_get);
        }
        public function Deserialize(ar:ByteArray):void
        {
            online_time = ar.readInt();
            is_get = ar.readInt();
        }
    }
}
