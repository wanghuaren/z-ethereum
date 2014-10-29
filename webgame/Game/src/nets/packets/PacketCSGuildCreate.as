package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *公会创建
    */
    public class PacketCSGuildCreate implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39224;
        /** 
        *公会名称
        */
        public var guildname:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            PacketFactory.Instance.WriteString(ar, guildname, 32);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var guildnameLength:int = ar.readInt();
            guildname = ar.readMultiByte(guildnameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
