package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *兑换CDKey礼包
    */
    public class PacketSDExchangeCDKey implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31009;
        /** 
        *分类ID
        */
        public var type:int;
        /** 
        *key
        */
        public var cdkey:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            PacketFactory.Instance.WriteString(ar, cdkey, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            var cdkeyLength:int = ar.readInt();
            cdkey = ar.readMultiByte(cdkeyLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
