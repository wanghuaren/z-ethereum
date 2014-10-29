package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *服务器详细信息
    */
    public class StructServer_Detail implements ISerializable
    {
        /** 
        *服务器ID
        */
        public var server_id:int;
        /** 
        *服务器状态
        */
        public var server_live:int;
        /** 
        *服务器异常数
        */
        public var server_exception:int;
        /** 
        *服务器状态
        */
        public var server_state:int;
        /** 
        *玩家数量
        */
        public var playercnt:int;
        /** 
        *是否本地服务器(跨服监控用)
        */
        public var islocal:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(server_id);
            ar.writeInt(server_live);
            ar.writeInt(server_exception);
            ar.writeInt(server_state);
            ar.writeInt(playercnt);
            ar.writeInt(islocal);
        }
        public function Deserialize(ar:ByteArray):void
        {
            server_id = ar.readInt();
            server_live = ar.readInt();
            server_exception = ar.readInt();
            server_state = ar.readInt();
            playercnt = ar.readInt();
            islocal = ar.readInt();
        }
    }
}
