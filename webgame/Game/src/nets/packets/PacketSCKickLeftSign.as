package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *被踢出副本报名队伍
    */
    public class PacketSCKickLeftSign implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20031;
        /** 
        *队伍id
        */
        public var signid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(signid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            signid = ar.readInt();
        }
    }
}
