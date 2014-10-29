package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *请求斗战神信息返回
    */
    public class PacketSCFFGList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 45001;
        /** 
        *服务器开放阶段 0 开放第一阶段 1 开放第二阶段 2 开放第三阶段
        */
        public var step:int;
        /** 
        *通关第一阶段人数
        */
        public var num1:int;
        /** 
        *通关第二阶段人数
        */
        public var num2:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(step);
            ar.writeInt(num1);
            ar.writeInt(num2);
        }
        public function Deserialize(ar:ByteArray):void
        {
            step = ar.readInt();
            num1 = ar.readInt();
            num2 = ar.readInt();
        }
    }
}
