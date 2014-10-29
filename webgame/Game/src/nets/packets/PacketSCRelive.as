package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家复活
    */
    public class PacketSCRelive implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14016;
        /** 
        *复活玩家id
        */
        public var userid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(userid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
        }
    }
}
