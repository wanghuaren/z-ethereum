package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *自由加入公会
    */
    public class PacketCSGuildAutoAccess implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39215;
        /** 
        *1:自动加入0:审批加入
        */
        public var autoAcess:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(autoAcess);
        }
        public function Deserialize(ar:ByteArray):void
        {
            autoAcess = ar.readInt();
        }
    }
}
