package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *删除领取消息
    */
    public class PacketSCPrizeMsgDel implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24605;
        /** 
        *领取消息奖励的编号
        */
        public var sn:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(sn);
        }
        public function Deserialize(ar:ByteArray):void
        {
            sn = ar.readInt();
        }
    }
}
