package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *皇城争霸信息
    */
    public class StructCityFightInfoData implements ISerializable
    {
        /** 
        *名次
        */
        public var no:int;
        /** 
        *人数
        */
        public var num:int;
        /** 
        *家族名称
        */
        public var guildname:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(no);
            ar.writeInt(num);
            PacketFactory.Instance.WriteString(ar, guildname, 32);
        }
        public function Deserialize(ar:ByteArray):void
        {
            no = ar.readInt();
            num = ar.readInt();
            var guildnameLength:int = ar.readInt();
            guildname = ar.readMultiByte(guildnameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
