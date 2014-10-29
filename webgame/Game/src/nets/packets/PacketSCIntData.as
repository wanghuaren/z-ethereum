package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *升级奖励
    */
    public class PacketSCIntData implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38900;
        /** 
        *升级奖励
        */
        public var levelupgift:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(levelupgift);
        }
        public function Deserialize(ar:ByteArray):void
        {
            levelupgift = ar.readInt();
        }
    }
}
