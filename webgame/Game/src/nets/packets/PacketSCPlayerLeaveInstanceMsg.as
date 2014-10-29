package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家离开副本
    */
    public class PacketSCPlayerLeaveInstanceMsg implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29023;
        /** 
        *副本类型1 玄黄 2 魔天 3 boss战 4 pk
        */
        public var instance_type:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(instance_type);
        }
        public function Deserialize(ar:ByteArray):void
        {
            instance_type = ar.readInt();
        }
    }
}
