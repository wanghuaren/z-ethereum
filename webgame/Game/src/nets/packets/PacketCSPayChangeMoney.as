package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *元宝换银两
    */
    public class PacketCSPayChangeMoney implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31003;
        /** 
        *角色编号
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
