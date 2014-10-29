package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *角色查看
    */
    public class PacketCSPlayerLookInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 28004;
        /** 
        *
        */
        public var role:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(role);
        }
        public function Deserialize(ar:ByteArray):void
        {
            role = ar.readInt();
        }
    }
}
