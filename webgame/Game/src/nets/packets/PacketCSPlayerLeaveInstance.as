package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家离开副本
    */
    public class PacketCSPlayerLeaveInstance implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20026;
        /** 
        *标识
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            flag = ar.readInt();
        }
    }
}
