package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *双倍经验数据
    */
    public class StructDoubleExpInfo implements ISerializable
    {
        /** 
        *本周时间,以秒为单位
        */
        public var systime:int;
        /** 
        *元宝时间,以秒为单位
        */
        public var rmbtime:int;
        /** 
        *已购买次数
        */
        public var buytimes:int;
        /** 
        *开启状态，1表示已开启，0表示关闭
        */
        public var state:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(systime);
            ar.writeInt(rmbtime);
            ar.writeInt(buytimes);
            ar.writeInt(state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            systime = ar.readInt();
            rmbtime = ar.readInt();
            buytimes = ar.readInt();
            state = ar.readInt();
        }
    }
}
