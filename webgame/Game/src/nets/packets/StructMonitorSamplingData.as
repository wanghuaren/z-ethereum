package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *监控采样结果
    */
    public class StructMonitorSamplingData implements ISerializable
    {
        /** 
        *服务器死活状态
        */
        public var ServerState:int;
        /** 
        *服务器异常数量,主要用于监控是否有新的异常继续产生
        */
        public var ExceptionCnt:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(ServerState);
            ar.writeInt(ExceptionCnt);
        }
        public function Deserialize(ar:ByteArray):void
        {
            ServerState = ar.readInt();
            ExceptionCnt = ar.readInt();
        }
    }
}
