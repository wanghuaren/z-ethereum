package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *申请玩家
    */
    public class StructGuildRequire implements ISerializable
    {
        /** 
        *player
        */
        public var playerid:int;
        /** 
        *名称
        */
        public var name:String = new String();
        /** 
        *等级
        */
        public var level:int;
        /** 
        *职业
        */
        public var metier:int;
        /** 
        *战力
        */
        public var faight:int;
        /** 
        *职位
        */
        public var job:int;
        /** 
        *贡献
        */
        public var active:int;
        /** 
        *vip
        */
        public var vip:int;
        /** 
        *qq黄钻VIP
        */
        public var qqyellowvip:int;
        /** 
        *离线时间 格式:YYMMDDHHMM 0标识当前在线
        */
        public var lasttime:int;
        /** 
        *威望
        */
        public var cachet:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(playerid);
            PacketFactory.Instance.WriteString(ar, name, 128);
            ar.writeInt(level);
            ar.writeInt(metier);
            ar.writeInt(faight);
            ar.writeInt(job);
            ar.writeInt(active);
            ar.writeInt(vip);
            ar.writeInt(qqyellowvip);
            ar.writeInt(lasttime);
            ar.writeInt(cachet);
        }
        public function Deserialize(ar:ByteArray):void
        {
            playerid = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            level = ar.readInt();
            metier = ar.readInt();
            faight = ar.readInt();
            job = ar.readInt();
            active = ar.readInt();
            vip = ar.readInt();
            qqyellowvip = ar.readInt();
            lasttime = ar.readInt();
            cachet = ar.readInt();
        }
    }
}
