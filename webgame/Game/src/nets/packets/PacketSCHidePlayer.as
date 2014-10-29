package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *显示隐藏周围玩家返回
    */
    public class PacketSCHidePlayer implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 1019;
        /** 
        *1表示显示，0表示隐藏
        */
        public var show:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(show);
        }
        public function Deserialize(ar:ByteArray):void
        {
            show = ar.readInt();
        }
    }
}
