package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *强化买星
    */
    public class PacketCSEquipStrongBuyStar implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15047;
        /** 
        *位置
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
