package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *buff信息
    */
    public class StructBuff implements ISerializable
    {
        /** 
        *buff编号
        */
        public var buffid:int;
        /** 
        *持续时间
        */
        public var needtime:int;
        /** 
        *剩余容量
        */
        public var remainCapacity:int;
        /** 
        *buff序号
        */
        public var sn:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(buffid);
            ar.writeInt(needtime);
            ar.writeInt(remainCapacity);
            ar.writeInt(sn);
        }
        public function Deserialize(ar:ByteArray):void
        {
            buffid = ar.readInt();
            needtime = ar.readInt();
            remainCapacity = ar.readInt();
            sn = ar.readInt();
        }
    }
}
