package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *掌教至尊地图旗帜信息
    */
    public class StructGuildFightInfoData implements ISerializable
    {
        /** 
        *旗帜编号 从0 开始 3结束
        */
        public var flag_no:int;
        /** 
        *家族id
        */
        public var guildId:int;
        /** 
        *家族名称
        */
        public var guildName:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(flag_no);
            ar.writeInt(guildId);
            PacketFactory.Instance.WriteString(ar, guildName, 32);
        }
        public function Deserialize(ar:ByteArray):void
        {
            flag_no = ar.readInt();
            guildId = ar.readInt();
            var guildNameLength:int = ar.readInt();
            guildName = ar.readMultiByte(guildNameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
