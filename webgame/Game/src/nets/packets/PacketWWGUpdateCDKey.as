package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *标记使用过得CDKey
    */
    public class PacketWWGUpdateCDKey implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31025;
        /** 
        *账号ID
        */
        public var accountid:int;
        /** 
        *key
        */
        public var cdkey:String = new String();
        /** 
        *成功或者失败
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(accountid);
            PacketFactory.Instance.WriteString(ar, cdkey, 128);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            accountid = ar.readInt();
            var cdkeyLength:int = ar.readInt();
            cdkey = ar.readMultiByte(cdkeyLength,PacketFactory.Instance.GetCharSet());
            tag = ar.readInt();
        }
    }
}
