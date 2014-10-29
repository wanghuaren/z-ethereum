package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取体验VIP信息返回
    */
    public class PacketSCGameTestVipInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31041;
        /** 
        *剩余时间,单位分钟
        */
        public var times:int;
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(times);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            times = ar.readInt();
            tag = ar.readInt();
        }
    }
}
