package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *进入boss战
    */
    public class PacketCSEntryBossAction implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29015;
        /** 
        *活动id
        */
        public var action_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(action_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            action_id = ar.readInt();
        }
    }
}
