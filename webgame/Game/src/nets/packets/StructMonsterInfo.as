package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *怪物信息
    */
    public class StructMonsterInfo implements ISerializable
    {
        /** 
        *怪物ID
        */
        public var objid:int;
        /** 
        *怪物名称
        */
        public var name:String = new String();
        /** 
        *拥有角色名称
        */
        public var playername:String = new String();
        /** 
        *拥有角色id
        */
        public var playerid:int;
        /** 
        *怪物标题
        */
        public var title:String = new String();
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
        *当前血量
        */
        public var hp:int;
        /** 
        *最大血量
        */
        public var maxhp:int;
        /** 
        *等级
        */
        public var level:int;
        /** 
        *当前mp
        */
        public var mp:int;
        /** 
        *最大mp
        */
        public var maxmp:int;
        /** 
        *类型
        */
        public var isnpc:int;
        /** 
        *阵营
        */
        public var camp:int;
        /** 
        *品质
        */
        public var grade:int;
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
        *技能效果1
        */
        public var buffeffect1:int;
        /** 
        *模板id
        */
        public var templateid:int;
        /** 
        *地图区域类型,1打怪区 2阵营区 3安全区
        */
        public var mapzonetype:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(objid);
            PacketFactory.Instance.WriteString(ar, name, 32);
            PacketFactory.Instance.WriteString(ar, playername, 32);
            ar.writeInt(playerid);
            PacketFactory.Instance.WriteString(ar, title, 32);
            ar.writeInt(mapid);
            ar.writeInt(mapx);
            ar.writeInt(mapy);
            ar.writeInt(maptox);
            ar.writeInt(maptoy);
            ar.writeInt(direct);
            ar.writeInt(hp);
            ar.writeInt(maxhp);
            ar.writeInt(level);
            ar.writeInt(mp);
            ar.writeInt(maxmp);
            ar.writeInt(isnpc);
            ar.writeInt(camp);
            ar.writeInt(grade);
            ar.writeInt(movspeed);
            ar.writeInt(atkspeed);
            ar.writeInt(buffeffect);
            ar.writeInt(buffeffect1);
            ar.writeInt(templateid);
            ar.writeInt(mapzonetype);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            var playernameLength:int = ar.readInt();
            playername = ar.readMultiByte(playernameLength,PacketFactory.Instance.GetCharSet());
            playerid = ar.readInt();
            var titleLength:int = ar.readInt();
            title = ar.readMultiByte(titleLength,PacketFactory.Instance.GetCharSet());
            mapid = ar.readInt();
            mapx = ar.readInt();
            mapy = ar.readInt();
            maptox = ar.readInt();
            maptoy = ar.readInt();
            direct = ar.readInt();
            hp = ar.readInt();
            maxhp = ar.readInt();
            level = ar.readInt();
            mp = ar.readInt();
            maxmp = ar.readInt();
            isnpc = ar.readInt();
            camp = ar.readInt();
            grade = ar.readInt();
            movspeed = ar.readInt();
            atkspeed = ar.readInt();
            buffeffect = ar.readInt();
            buffeffect1 = ar.readInt();
            templateid = ar.readInt();
            mapzonetype = ar.readInt();
        }
    }
}
