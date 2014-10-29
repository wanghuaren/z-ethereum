package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *抽奖
    */
    public class PacketSCInviteLuckDraw implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 37018;
        /** 
        *获奖日志
        */
        public var tag:int;
        /** 
        *获奖编号
        */
        public var itemid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(itemid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            itemid = ar.readInt();
        }
    }
}
