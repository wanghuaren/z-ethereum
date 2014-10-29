package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *兑换CDKey礼包
    */
    public class PacketWWGExchangeCDKey implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31023;
        /** 
        *账号ID
        */
        public var accountid:int;
        /** 
        *key
        */
        public var cdkey:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(accountid);
            PacketFactory.Instance.WriteString(ar, cdkey, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            accountid = ar.readInt();
            var cdkeyLength:int = ar.readInt();
            cdkey = ar.readMultiByte(cdkeyLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
