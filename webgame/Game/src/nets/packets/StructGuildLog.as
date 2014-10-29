package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *公会记录
    */
    public class StructGuildLog implements ISerializable
    {
        /** 
        *type:1人事2贡献
        */
        public var type:int;
        /** 
        *玩家vip
        */
        public var vip:int;
        /** 
        *log时间，格式:YYYYMMDD
        */
        public var time:int;
        /** 
        *log
        */
        public var player_log:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(type);
            ar.writeInt(vip);
            ar.writeInt(time);
            PacketFactory.Instance.WriteString(ar, player_log, 256);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            vip = ar.readInt();
            time = ar.readInt();
            var player_logLength:int = ar.readInt();
            player_log = ar.readMultiByte(player_logLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
