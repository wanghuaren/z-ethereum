package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructPrizeMsgInfo2
    /** 
    *新领取消息
    */
    public class PacketSCPrizeMsgNew implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24604;
        /** 
        *消息奖励信息
        */
        public var list:StructPrizeMsgInfo2 = new StructPrizeMsgInfo2();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            list.Serialize(ar);
        }
        public function Deserialize(ar:ByteArray):void
        {
            list.Deserialize(ar);
        }
    }
}
