package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *修改家族boss活动时间
    */
    public class PacketCSSetGuildBossTime implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39404;
        /** 
        *活动时间 1120格式
        */
        public var time:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(time);
        }
        public function Deserialize(ar:ByteArray):void
        {
            time = ar.readInt();
        }
    }
}
