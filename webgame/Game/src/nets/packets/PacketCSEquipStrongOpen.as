package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *开强化槽
    */
    public class PacketCSEquipStrongOpen implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15005;
        /** 
        *那一个强化槽
        */
        public var pos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readInt();
        }
    }
}
