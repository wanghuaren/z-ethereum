package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *系统设置
    */
    public class PacketSCSystemSetting implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 19002;
        /** 
        *设置
        */
        public var setting:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(setting);
        }
        public function Deserialize(ar:ByteArray):void
        {
            setting = ar.readInt();
        }
    }
}
