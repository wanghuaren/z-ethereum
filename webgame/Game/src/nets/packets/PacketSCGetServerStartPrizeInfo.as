package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得开服嘉年华奖励参与信息返回
    */
    public class PacketSCGetServerStartPrizeInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39801;
        /** 
        *奖励信息 每2位代表 总计十天20位 0未完成 1 可领取 2 领取过 
        */
        public var info:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(info);
        }
        public function Deserialize(ar:ByteArray):void
        {
            info = ar.readInt();
        }
    }
}
