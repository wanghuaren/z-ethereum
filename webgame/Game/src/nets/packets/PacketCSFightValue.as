package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *战力值
    */
    public class PacketCSFightValue implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24500;
        /** 
        *角色id  0为自己
        */
        public var roleid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
        }
    }
}
