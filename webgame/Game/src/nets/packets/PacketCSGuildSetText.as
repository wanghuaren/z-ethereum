package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *公会信息设置
    */
    public class PacketCSGuildSetText implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39238;
        /** 
        *公会
        */
        public var guildid:int;
        /** 
        *公告
        */
        public var bull:String = new String();
        /** 
        *介绍
        */
        public var desc:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(guildid);
            PacketFactory.Instance.WriteString(ar, bull, 512);
            PacketFactory.Instance.WriteString(ar, desc, 512);
        }
        public function Deserialize(ar:ByteArray):void
        {
            guildid = ar.readInt();
            var bullLength:int = ar.readInt();
            bull = ar.readMultiByte(bullLength,PacketFactory.Instance.GetCharSet());
            var descLength:int = ar.readInt();
            desc = ar.readMultiByte(descLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
