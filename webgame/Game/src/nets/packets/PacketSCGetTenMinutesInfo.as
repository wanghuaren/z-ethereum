package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *10分有礼信息返回
    */
    public class PacketSCGetTenMinutesInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54803;
        /** 
        *等待时间
        */
        public var times:int;
        /** 
        *领取状态: 0，未领取；1，已经领取
        */
        public var status:int;
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(times);
            ar.writeInt(status);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            times = ar.readInt();
            status = ar.readInt();
            tag = ar.readInt();
        }
    }
}
