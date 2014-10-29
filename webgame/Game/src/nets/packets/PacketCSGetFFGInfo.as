package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *请求斗战神通关最快信息
    */
    public class PacketCSGetFFGInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 45003;
        /** 
        *服务器开放阶段 0 开放第一阶段 1 开放第二阶段 2 开放第三阶段
        */
        public var step:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(step);
        }
        public function Deserialize(ar:ByteArray):void
        {
            step = ar.readInt();
        }
    }
}
