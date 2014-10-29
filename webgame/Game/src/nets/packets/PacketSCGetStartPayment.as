package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取开服充值奖励
    */
    public class PacketSCGetStartPayment implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31112;
        /** 
        *返回结果
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
        }
    }
}
