package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *踢出队伍报名
    */
    public class PacketCSKickPlayer implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20013;
        /** 
        *报名id
        */
        public var signid:int;
        /** 
        *踢出玩家id
        */
        public var roleid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(signid);
            ar.writeInt(roleid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            signid = ar.readInt();
            roleid = ar.readInt();
        }
    }
}
