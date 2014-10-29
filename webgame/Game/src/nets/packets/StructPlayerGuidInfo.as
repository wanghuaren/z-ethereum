package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家指引
    */
    public class StructPlayerGuidInfo implements ISerializable
    {
        /** 
        *类型
        */
        public var type:int;
        /** 
        *数量
        */
        public var value:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(type);
            ar.writeInt(value);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            value = ar.readInt();
        }
    }
}
