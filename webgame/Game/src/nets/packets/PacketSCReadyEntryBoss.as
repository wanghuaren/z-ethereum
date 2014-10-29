package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *boss提示,准备进入boss战
    */
    public class PacketSCReadyEntryBoss implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29014;
        /** 
        *活动id
        */
        public var action_id:int;
        /** 
        *最大等级
        */
        public var max_level:int;
        /** 
        *最小等级
        */
        public var min_level:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(action_id);
            ar.writeInt(max_level);
            ar.writeInt(min_level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            action_id = ar.readInt();
            max_level = ar.readInt();
            min_level = ar.readInt();
        }
    }
}
