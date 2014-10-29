package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *是否检测加速外挂
    */
    public class PacketSCIsCheckHack implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54091;
        /** 
        *是否检测外挂 0 不检测 1 检测
        */
        public var is_check:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(is_check);
        }
        public function Deserialize(ar:ByteArray):void
        {
            is_check = ar.readInt();
        }
    }
}
