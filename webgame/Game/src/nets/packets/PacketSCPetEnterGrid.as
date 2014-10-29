package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *宠物进入视野
    */
    public class PacketSCPetEnterGrid implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 1013;
        /** 
        *宠物ID
        */
        public var petid:int;
        /** 
        *宠物名称
        */
        public var name:String = new String();
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
        *皮肤
        */
        public var outlook:int;
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
        *是否npc
        */
        public var isnpc:int;
        /** 
        *阵营
        */
        public var camp:int;
        /** 
        *移动速度
        */
        public var movspeed:int;
        /** 
        *等级
        */
        public var level:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(petid);
            PacketFactory.Instance.WriteString(ar, name, 32);
            ar.writeInt(mapid);
            ar.writeInt(mapx);
            ar.writeInt(mapy);
            ar.writeInt(maptox);
            ar.writeInt(maptoy);
            ar.writeInt(direct);
            ar.writeInt(outlook);
            ar.writeInt(hp);
            ar.writeInt(maxhp);
            ar.writeInt(mp);
            ar.writeInt(maxmp);
            ar.writeInt(isnpc);
            ar.writeInt(camp);
            ar.writeInt(movspeed);
            ar.writeInt(level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            petid = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            mapid = ar.readInt();
            mapx = ar.readInt();
            mapy = ar.readInt();
            maptox = ar.readInt();
            maptoy = ar.readInt();
            direct = ar.readInt();
            outlook = ar.readInt();
            hp = ar.readInt();
            maxhp = ar.readInt();
            mp = ar.readInt();
            maxmp = ar.readInt();
            isnpc = ar.readInt();
            camp = ar.readInt();
            movspeed = ar.readInt();
            level = ar.readInt();
        }
    }
}
