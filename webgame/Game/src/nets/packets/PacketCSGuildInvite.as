package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *邀请加入公会
    */
    public class PacketCSGuildInvite implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39242;
        /** 
        *被邀请者名字
        */
        public var playername:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            PacketFactory.Instance.WriteString(ar, playername, 32);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var playernameLength:int = ar.readInt();
            playername = ar.readMultiByte(playernameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
