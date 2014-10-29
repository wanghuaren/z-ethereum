package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *邀请目标的回馈
    */
    public class PacketCSTeamInvitR implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 18004;
        /** 
        *邀请玩家ID
        */
        public var roleid:int;
        /** 
        *结果1同意0不同意
        */
        public var result:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleid);
            ar.writeInt(result);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            result = ar.readInt();
        }
    }
}
