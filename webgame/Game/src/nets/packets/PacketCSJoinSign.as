package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *加入副本报名队伍
    */
    public class PacketCSJoinSign implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20007;
        /** 
        *报名id
        */
        public var signid:int;
        /** 
        *副本组id
        */
        public var groupid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(signid);
            ar.writeInt(groupid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            signid = ar.readInt();
            groupid = ar.readInt();
        }
    }
}
