package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *队友详细信息
    */
    public class PacketSCTeamMemberDesc implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 18025;
        /** 
        *队友
        */
        public var roleid:int;
        /** 
        *在线状态
        */
        public var online:int;
        /** 
        *名字
        */
        public var name:String = new String();
        /** 
        *职业
        */
        public var metier:int;
        /** 
        *等级
        */
        public var level:int;
        /** 
        *VIP
        */
        public var vip:int;
        /** 
        *QQVIP
        */
        public var qqyellowvip:int;
        /** 
        *头像
        */
        public var head:int;
        /** 
        *生命
        */
        public var hp:int;
        /** 
        *最大生命
        */
        public var maxhp:int;
        /** 
        *魔法
        */
        public var mp:int;
        /** 
        *最大魔法
        */
        public var maxmp:int;
        /** 
        *所在地图
        */
        public var mapid:int;
        /** 
        *x坐标
        */
        public var mapx:int;
        /** 
        *y坐标
        */
        public var mapy:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleid);
            ar.writeInt(online);
            PacketFactory.Instance.WriteString(ar, name, 64);
            ar.writeInt(metier);
            ar.writeInt(level);
            ar.writeInt(vip);
            ar.writeInt(qqyellowvip);
            ar.writeInt(head);
            ar.writeInt(hp);
            ar.writeInt(maxhp);
            ar.writeInt(mp);
            ar.writeInt(maxmp);
            ar.writeInt(mapid);
            ar.writeInt(mapx);
            ar.writeInt(mapy);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            online = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            metier = ar.readInt();
            level = ar.readInt();
            vip = ar.readInt();
            qqyellowvip = ar.readInt();
            head = ar.readInt();
            hp = ar.readInt();
            maxhp = ar.readInt();
            mp = ar.readInt();
            maxmp = ar.readInt();
            mapid = ar.readInt();
            mapx = ar.readInt();
            mapy = ar.readInt();
        }
    }
}
