package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *排行榜角色查看
    */
    public class PacketCSRankPlayerInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 28002;
        /** 
        *
        */
        public var role:int;
        /** 
        *
        */
        public var pet:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(role);
            ar.writeInt(pet);
        }
        public function Deserialize(ar:ByteArray):void
        {
            role = ar.readInt();
            pet = ar.readInt();
        }
    }
}
