package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *战力值
    */
    public class PacketSCFightValue implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24501;
        /** 
        *
        */
        public var tag:int;
        /** 
        *vip等级
        */
        public var vip:int;
        /** 
        *战力值排行
        */
        public var ranklevel:int;
        /** 
        *人物等级
        */
        public var playerlevel:int;
        /** 
        *人物头像
        */
        public var playericon:int;
        /** 
        *人物职业
        */
        public var playermetier:int;
        /** 
        *人物名称
        */
        public var playername:String = new String();
        /** 
        *人物基础战力值
        */
        public var player:int;
        /** 
        *装备基础战力值
        */
        public var playerequipbase:int;
        /** 
        *装备附加属性战力值
        */
        public var playerequipapp:int;
        /** 
        *装备强化战力值
        */
        public var playerequipstrong:int;
        /** 
        *装备魔纹战力值
        */
        public var playerequipevilgrain:int;
        /** 
        *装备噬魂战力值
        */
        public var playerequipsoulstrong:int;
        /** 
        *人物炼骨战力值
        */
        public var playerbone:int;
        /** 
        *人物星魂战力值
        */
        public var playerstart:int;
        /** 
        *人物内丹战力值
        */
        public var playerpill:int;
        /** 
        *人物坐骑战力值
        */
        public var playerhourse:int;
        /** 
        *宠物基础战力值
        */
        public var pet:int;
        /** 
        *装备基础战力值
        */
        public var petequipbase:int;
        /** 
        *装备附加属性战力值
        */
        public var petequipapp:int;
        /** 
        *装备强化战力值
        */
        public var petequipstrong:int;
        /** 
        *装备魔纹战力值
        */
        public var petequipevilgrain:int;
        /** 
        *人物星魂战力值
        */
        public var petstart:int;
        /** 
        *人物内丹战力值
        */
        public var petpill:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(vip);
            ar.writeInt(ranklevel);
            ar.writeInt(playerlevel);
            ar.writeInt(playericon);
            ar.writeInt(playermetier);
            PacketFactory.Instance.WriteString(ar, playername, 50);
            ar.writeInt(player);
            ar.writeInt(playerequipbase);
            ar.writeInt(playerequipapp);
            ar.writeInt(playerequipstrong);
            ar.writeInt(playerequipevilgrain);
            ar.writeInt(playerequipsoulstrong);
            ar.writeInt(playerbone);
            ar.writeInt(playerstart);
            ar.writeInt(playerpill);
            ar.writeInt(playerhourse);
            ar.writeInt(pet);
            ar.writeInt(petequipbase);
            ar.writeInt(petequipapp);
            ar.writeInt(petequipstrong);
            ar.writeInt(petequipevilgrain);
            ar.writeInt(petstart);
            ar.writeInt(petpill);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            vip = ar.readInt();
            ranklevel = ar.readInt();
            playerlevel = ar.readInt();
            playericon = ar.readInt();
            playermetier = ar.readInt();
            var playernameLength:int = ar.readInt();
            playername = ar.readMultiByte(playernameLength,PacketFactory.Instance.GetCharSet());
            player = ar.readInt();
            playerequipbase = ar.readInt();
            playerequipapp = ar.readInt();
            playerequipstrong = ar.readInt();
            playerequipevilgrain = ar.readInt();
            playerequipsoulstrong = ar.readInt();
            playerbone = ar.readInt();
            playerstart = ar.readInt();
            playerpill = ar.readInt();
            playerhourse = ar.readInt();
            pet = ar.readInt();
            petequipbase = ar.readInt();
            petequipapp = ar.readInt();
            petequipstrong = ar.readInt();
            petequipevilgrain = ar.readInt();
            petstart = ar.readInt();
            petpill = ar.readInt();
        }
    }
}
