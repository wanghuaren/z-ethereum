package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *抽奖
    */
    public class PacketSCLuckDraw implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 37006;
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *已抽奖次数
        */
        public var times:int;
        /** 
        *中奖物品id
        */
        public var curgiftId:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(times);
            ar.writeInt(curgiftId);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            times = ar.readInt();
            curgiftId = ar.readInt();
        }
    }
}
