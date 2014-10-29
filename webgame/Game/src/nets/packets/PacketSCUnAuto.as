package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *停止挂机
    */
    public class PacketSCUnAuto implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 25002;
        /** 
        *1：没有挂机时间 2：5分钟死2此  
        */
        public var type:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
        }
    }
}
