package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *寻宝
    */
    public class PacketCSDiscoveringTreasure implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 43201;
        /** 
        *1:寻宝1次 2:寻宝10次 3:寻宝50次
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
