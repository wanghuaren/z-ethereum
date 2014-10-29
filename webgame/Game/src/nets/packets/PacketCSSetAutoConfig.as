package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *设置挂机配置
    */
    public class PacketCSSetAutoConfig implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 25005;
        /** 
        *config
        */
        public var config:int;
        /** 
        *config
        */
        public var config1:int;
        /** 
        *config
        */
        public var config2:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(config);
            ar.writeInt(config1);
            ar.writeInt(config2);
        }
        public function Deserialize(ar:ByteArray):void
        {
            config = ar.readInt();
            config1 = ar.readInt();
            config2 = ar.readInt();
        }
    }
}
