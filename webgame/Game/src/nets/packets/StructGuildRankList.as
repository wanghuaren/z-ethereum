package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *家族大乱斗排行数据
    */
    public class StructGuildRankList implements ISerializable
    {
        /** 
        *家族排名
        */
        public var guildNo:int;
        /** 
        *家族id
        */
        public var guildId:int;
        /** 
        *家族积分
        */
        public var value:int;
        /** 
        *家族名称
        */
        public var guildName:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(guildNo);
            ar.writeInt(guildId);
            ar.writeInt(value);
            PacketFactory.Instance.WriteString(ar, guildName, 32);
        }
        public function Deserialize(ar:ByteArray):void
        {
            guildNo = ar.readInt();
            guildId = ar.readInt();
            value = ar.readInt();
            var guildNameLength:int = ar.readInt();
            guildName = ar.readMultiByte(guildNameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
