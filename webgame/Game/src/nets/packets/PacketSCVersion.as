package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *版本
    */
    public class PacketSCVersion implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 97;
        /** 
        *版本信息
        */
        public var version:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            PacketFactory.Instance.WriteString(ar, version, 256);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var versionLength:int = ar.readInt();
            version = ar.readMultiByte(versionLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
