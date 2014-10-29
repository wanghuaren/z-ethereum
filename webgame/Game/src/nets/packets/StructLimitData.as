package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *角色限制数据
    */
    public class StructLimitData implements ISerializable
    {
        /** 
        *ID
        */
        public var limitid:int;
        /** 
        *日期
        */
        public var day:int;
        /** 
        *次数
        */
        public var times:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(limitid);
            ar.writeInt(day);
            ar.writeInt(times);
        }
        public function Deserialize(ar:ByteArray):void
        {
            limitid = ar.readInt();
            day = ar.readInt();
            times = ar.readInt();
        }
    }
}
