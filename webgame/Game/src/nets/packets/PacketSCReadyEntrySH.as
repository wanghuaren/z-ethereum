package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *准备进入server hero
    */
    public class PacketSCReadyEntrySH implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53002;
        /** 
        *活动id
        */
        public var action_id:int;
        /** 
        *战斗力
        */
        public var fight_value:int;
        /** 
        *最小等级
        */
        public var min_level:int;
        /** 
        *最大等级
        */
        public var max_level:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(action_id);
            ar.writeInt(fight_value);
            ar.writeInt(min_level);
            ar.writeInt(max_level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            action_id = ar.readInt();
            fight_value = ar.readInt();
            min_level = ar.readInt();
            max_level = ar.readInt();
        }
    }
}
