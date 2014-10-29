package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *准备进入server pk
    */
    public class PacketSCReadyEntryServerPK implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 40004;
        /** 
        *活动阶段
        */
        public var action_step:int;
        /** 
        *活动id
        */
        public var action_id:int;
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
            ar.writeInt(action_step);
            ar.writeInt(action_id);
            ar.writeInt(min_level);
            ar.writeInt(max_level);
        }
        public function Deserialize(ar:ByteArray):void
        {
            action_step = ar.readInt();
            action_id = ar.readInt();
            min_level = ar.readInt();
            max_level = ar.readInt();
        }
    }
}
