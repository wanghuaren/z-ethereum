package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *服务器状态
    */
    public class StructServerState implements ISerializable
    {
        /** 
        *服务器ID
        */
        public var ServerID:int;
        /** 
        *服务器状态
        */
        public var State:int;
        /** 
        *玩家数量
        */
        public var PlayerCnt:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(ServerID);
            ar.writeInt(State);
            ar.writeInt(PlayerCnt);
        }
        public function Deserialize(ar:ByteArray):void
        {
            ServerID = ar.readInt();
            State = ar.readInt();
            PlayerCnt = ar.readInt();
        }
    }
}
