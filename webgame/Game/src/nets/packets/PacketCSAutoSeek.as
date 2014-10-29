package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *自动寻路
    */
    public class PacketCSAutoSeek implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 13005;
        /** 
        *寻路编号
        */
        public var seekid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(seekid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            seekid = ar.readInt();
        }
    }
}
