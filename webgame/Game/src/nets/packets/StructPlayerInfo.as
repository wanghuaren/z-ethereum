package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *角色信息
    */
    public class StructPlayerInfo implements ISerializable
    {
        /** 
        *角色ID
        */
        public var roleID:int;
        /** 
        *角色名字
        */
        public var rolename:String = new String();
        /** 
        *地图ID
        */
        public var mapid:int;
        /** 
        *地图X
        */
        public var mapx:int;
        /** 
        *地图Y
        */
        public var mapy:int;
        /** 
        *移动到地图X
        */
        public var maptox:int;
        /** 
        *移动到地图Y
        */
        public var maptoy:int;
        /** 
        *方向
        */
        public var direct:int;
        /** 
        *职业
        */
        public var metier:int;
        /** 
        *性别
        */
        public var sex:int;
        /** 
        *等级
        */
        public var level:int;
        /** 
        *头像
        */
        public var icon:int;
        /** 
        *当前血量
        */
        public var hp:int;
        /** 
        *最大血量
        */
        public var maxhp:int;
        /** 
        *当前mp
        */
        public var mp:int;
        /** 
        *最大mp
        */
        public var maxmp:int;
        /** 
        *皮肤数据
        */
        public var s0:int;
        /** 
        *皮肤数据
        */
        public var s1:int;
        /** 
        *皮肤数据
        */
        public var s2:int;
        /** 
        *皮肤数据
        */
        public var s3:int;
        /** 
        *外形效果
        */
        public var r1:int;
        /** 
        *基本阵营（1代表无阵营玩家，2代表太乙，3代表通天）
        */
        public var basecamp:int;
        /** 
        *阵营
        */
        public var camp:int;
        /** 
        *移动速度
        */
        public var movspeed:int;
        /** 
        *攻击速度
        */
        public var atkspeed:int;
        /** 
        *技能效果
        */
        public var buffeffect:int;
        /** 
        *队伍id
        */
        public var teamid:int;
        /** 
        *队长id
        */
        public var teamleader:int;
        /** 
        *是否在修炼,0表示没有修炼，1表示正在修炼，2表示离线修炼，3表示主合体，4表示被合体，5表示摆摊状态
        */
        public var exercise:int;
        /** 
        *pk模式
        */
        public var pkmode:int;
        /** 
        *地图区域类型,1打怪区 2阵营区 3安全区
        */
        public var mapzonetype:int;
        /** 
        *称号
        */
        public var Title:int;
        /** 
        *VIP
        */
        public var vip:int;
        /** 
        *qq黄钻等级
        */
        public var qqyellowvip:int;
        /** 
        *家族id
        */
        public var guildid:int;
        /** 
        *家族名称
        */
        public var guildname:String = new String();
        /** 
        *职位名称
        */
        public var guildduty:int;
        /** 
        *是否皇族,1表示是，0表示不是
        */
        public var guildiswin:int;
        /** 
        *合体人id
        */
        public var coupleid:int;
        /** 
        *是否处于西天取经
        */
        public var isxiyou:int;
        /** 
        *是否处于跳跃移动1表示是，0表示不是
        */
        public var isjump:int;
        /** 
        *队伍人数
        */
        public var teamnum:int;
        /** 
        *摊位名称
        */
        public var boothname:String = new String();
        /** 
        *PK值
        */
        public var pkvalue:int;
        /** 
        *功勋等级
        */
        public var ploitLv:int;
        /** 
        *妻子名称
        */
        public var wifename:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(roleID);
            PacketFactory.Instance.WriteString(ar, rolename, 32);
            ar.writeInt(mapid);
            ar.writeInt(mapx);
            ar.writeInt(mapy);
            ar.writeInt(maptox);
            ar.writeInt(maptoy);
            ar.writeInt(direct);
            ar.writeInt(metier);
            ar.writeInt(sex);
            ar.writeInt(level);
            ar.writeInt(icon);
            ar.writeInt(hp);
            ar.writeInt(maxhp);
            ar.writeInt(mp);
            ar.writeInt(maxmp);
            ar.writeInt(s0);
            ar.writeInt(s1);
            ar.writeInt(s2);
            ar.writeInt(s3);
            ar.writeInt(r1);
            ar.writeInt(basecamp);
            ar.writeInt(camp);
            ar.writeInt(movspeed);
            ar.writeInt(atkspeed);
            ar.writeInt(buffeffect);
            ar.writeInt(teamid);
            ar.writeInt(teamleader);
            ar.writeInt(exercise);
            ar.writeInt(pkmode);
            ar.writeInt(mapzonetype);
            ar.writeInt(Title);
            ar.writeInt(vip);
            ar.writeInt(qqyellowvip);
            ar.writeInt(guildid);
            PacketFactory.Instance.WriteString(ar, guildname, 32);
            ar.writeInt(guildduty);
            ar.writeInt(guildiswin);
            ar.writeInt(coupleid);
            ar.writeInt(isxiyou);
            ar.writeInt(isjump);
            ar.writeInt(teamnum);
            PacketFactory.Instance.WriteString(ar, boothname, 20);
            ar.writeInt(pkvalue);
            ar.writeInt(ploitLv);
            PacketFactory.Instance.WriteString(ar, wifename, 32);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleID = ar.readInt();
            var rolenameLength:int = ar.readInt();
            rolename = ar.readMultiByte(rolenameLength,PacketFactory.Instance.GetCharSet());
            mapid = ar.readInt();
            mapx = ar.readInt();
            mapy = ar.readInt();
            maptox = ar.readInt();
            maptoy = ar.readInt();
            direct = ar.readInt();
            metier = ar.readInt();
            sex = ar.readInt();
            level = ar.readInt();
            icon = ar.readInt();
            hp = ar.readInt();
            maxhp = ar.readInt();
            mp = ar.readInt();
            maxmp = ar.readInt();
            s0 = ar.readInt();
            s1 = ar.readInt();
            s2 = ar.readInt();
            s3 = ar.readInt();
            r1 = ar.readInt();
            basecamp = ar.readInt();
            camp = ar.readInt();
            movspeed = ar.readInt();
            atkspeed = ar.readInt();
            buffeffect = ar.readInt();
            teamid = ar.readInt();
            teamleader = ar.readInt();
            exercise = ar.readInt();
            pkmode = ar.readInt();
            mapzonetype = ar.readInt();
            Title = ar.readInt();
            vip = ar.readInt();
            qqyellowvip = ar.readInt();
            guildid = ar.readInt();
            var guildnameLength:int = ar.readInt();
            guildname = ar.readMultiByte(guildnameLength,PacketFactory.Instance.GetCharSet());
            guildduty = ar.readInt();
            guildiswin = ar.readInt();
            coupleid = ar.readInt();
            isxiyou = ar.readInt();
            isjump = ar.readInt();
            teamnum = ar.readInt();
            var boothnameLength:int = ar.readInt();
            boothname = ar.readMultiByte(boothnameLength,PacketFactory.Instance.GetCharSet());
            pkvalue = ar.readInt();
            ploitLv = ar.readInt();
            var wifenameLength:int = ar.readInt();
            wifename = ar.readMultiByte(wifenameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
