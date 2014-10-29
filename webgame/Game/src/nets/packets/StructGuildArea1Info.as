package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *工会领地争夺1奖励信息
    */
    public class StructGuildArea1Info implements ISerializable
    {
        /** 
        *地图id
        */
        public var mapid:int;
        /** 
        *占领工会
        */
        public var guildname:String = new String();
        /** 
        *占领工会会长名称
        */
        public var leadername:String = new String();
        /** 
        *占领天数
        */
        public var win_day:int;
        /** 
        *今日领取次数
        */
        public var loot_num:int;
        /** 
        *地图是否开启
        */
        public var is_open:int;
        /** 
        *领取信息 0 不能领取 1 可以领取
        */
        public var prize_flag:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(mapid);
            PacketFactory.Instance.WriteString(ar, guildname, 64);
            PacketFactory.Instance.WriteString(ar, leadername, 64);
            ar.writeInt(win_day);
            ar.writeInt(loot_num);
            ar.writeInt(is_open);
            ar.writeInt(prize_flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            mapid = ar.readInt();
            var guildnameLength:int = ar.readInt();
            guildname = ar.readMultiByte(guildnameLength,PacketFactory.Instance.GetCharSet());
            var leadernameLength:int = ar.readInt();
            leadername = ar.readMultiByte(leadernameLength,PacketFactory.Instance.GetCharSet());
            win_day = ar.readInt();
            loot_num = ar.readInt();
            is_open = ar.readInt();
            prize_flag = ar.readInt();
        }
    }
}
