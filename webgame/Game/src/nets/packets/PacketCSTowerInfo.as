package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得魔天万界信息
    */
    public class PacketCSTowerInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29009;
        /** 
        *阶段，默认从0开始
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
