package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家重置魔天万界
    */
    public class PacketCSPlayerResetTower implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29024;
        /** 
        *魔天万界的阶数，默认为0
        */
        public var step:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(step);
        }
        public function Deserialize(ar:ByteArray):void
        {
            step = ar.readInt();
        }
    }
}
