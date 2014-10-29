package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *邀请加入公会
    */
    public class PacketCSGuildInviteR implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39244;
        /** 
        *1:同意，0:不同意
        */
        public var agree:int;
        /** 
        *邀请者名字
        */
        public var name:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(agree);
            PacketFactory.Instance.WriteString(ar, name, 32);
        }
        public function Deserialize(ar:ByteArray):void
        {
            agree = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
