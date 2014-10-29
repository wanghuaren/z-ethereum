package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *战力值
    */
    public class StructGradeInfo implements ISerializable
    {
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
        *人物星魂战力值
        */
        public var petstart:int;
        /** 
        *人物内丹战力值
        */
        public var petpill:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(player);
            ar.writeInt(playerequipbase);
            ar.writeInt(playerequipapp);
            ar.writeInt(playerequipstrong);
            ar.writeInt(playerbone);
            ar.writeInt(playerstart);
            ar.writeInt(playerpill);
            ar.writeInt(playerhourse);
            ar.writeInt(pet);
            ar.writeInt(petequipbase);
            ar.writeInt(petequipapp);
            ar.writeInt(petequipstrong);
            ar.writeInt(petstart);
            ar.writeInt(petpill);
        }
        public function Deserialize(ar:ByteArray):void
        {
            player = ar.readInt();
            playerequipbase = ar.readInt();
            playerequipapp = ar.readInt();
            playerequipstrong = ar.readInt();
            playerbone = ar.readInt();
            playerstart = ar.readInt();
            playerpill = ar.readInt();
            playerhourse = ar.readInt();
            pet = ar.readInt();
            petequipbase = ar.readInt();
            petequipapp = ar.readInt();
            petequipstrong = ar.readInt();
            petstart = ar.readInt();
            petpill = ar.readInt();
        }
    }
}
