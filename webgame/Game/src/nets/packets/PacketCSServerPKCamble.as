package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家押注
    */
    public class PacketCSServerPKCamble implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 40007;
        /** 
        *押注玩家编号
        */
        public var no:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(no);
        }
        public function Deserialize(ar:ByteArray):void
        {
            no = ar.readInt();
        }
    }
}
