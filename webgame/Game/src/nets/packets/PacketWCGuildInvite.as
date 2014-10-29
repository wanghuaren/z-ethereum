package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *邀请加入公会
    */
    public class PacketWCGuildInvite implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39243;
        /** 
        *推荐：1，邀请：2
        */
        public var type:int;
        /** 
        *邀请者名字
        */
        public var name:String = new String();
        /** 
        *邀请者公会名字
        */
        public var guildname:String = new String();
        /** 
        *错误码
        */
        public var tag:int;
        /** 
        *错误信息
        */
        public var msg:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            PacketFactory.Instance.WriteString(ar, name, 32);
            PacketFactory.Instance.WriteString(ar, guildname, 32);
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 256);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            var guildnameLength:int = ar.readInt();
            guildname = ar.readMultiByte(guildnameLength,PacketFactory.Instance.GetCharSet());
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
