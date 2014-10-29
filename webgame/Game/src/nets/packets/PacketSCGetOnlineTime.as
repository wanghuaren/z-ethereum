package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取在线时间
    */
    public class PacketSCGetOnlineTime implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31018;
        /** 
        *在线时间
        */
        public var time:int;
        /** 
        *元宝数量
        */
        public var rmb:int;
        /** 
        *当前次数
        */
        public var current:int;
        /** 
        *下次时间
        */
        public var nexttime:int;
        /** 
        *下次金钱
        */
        public var nextrmb:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(time);
            ar.writeInt(rmb);
            ar.writeInt(current);
            ar.writeInt(nexttime);
            ar.writeInt(nextrmb);
        }
        public function Deserialize(ar:ByteArray):void
        {
            time = ar.readInt();
            rmb = ar.readInt();
            current = ar.readInt();
            nexttime = ar.readInt();
            nextrmb = ar.readInt();
        }
    }
}
