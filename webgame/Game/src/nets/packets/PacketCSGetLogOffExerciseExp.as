package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取离线修炼经验
    */
    public class PacketCSGetLogOffExerciseExp implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 23208;
        /** 
        *1 单倍， 2 双倍， 3 3倍
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
