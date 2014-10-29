package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *兑换CDKey礼包
    */
    public class PacketSWExchangeCDKey implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31020;
        /** 
        *key
        */
        public var cdkey:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            PacketFactory.Instance.WriteString(ar, cdkey, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var cdkeyLength:int = ar.readInt();
            cdkey = ar.readMultiByte(cdkeyLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
