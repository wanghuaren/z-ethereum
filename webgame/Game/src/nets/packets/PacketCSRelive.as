package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家复活
    */
    public class PacketCSRelive implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 14014;
        /** 
        *复活模式,1表示原地复活,2表示回城复活
        */
        public var mode:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(mode);
        }
        public function Deserialize(ar:ByteArray):void
        {
            mode = ar.readInt();
        }
    }
}
