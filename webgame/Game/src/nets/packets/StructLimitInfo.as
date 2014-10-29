package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *限制id信息
    */
    public class StructLimitInfo implements ISerializable
    {
        /** 
        *限制id
        */
        public var limitid:int;
        /** 
        *当前次数
        */
        public var curnum:int;
        /** 
        *最大次数
        */
        public var maxnum:int;
        /** 
        *rmb最大次数
        */
        public var rmbmaxnum:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(limitid);
            ar.writeInt(curnum);
            ar.writeInt(maxnum);
            ar.writeInt(rmbmaxnum);
        }
        public function Deserialize(ar:ByteArray):void
        {
            limitid = ar.readInt();
            curnum = ar.readInt();
            maxnum = ar.readInt();
            rmbmaxnum = ar.readInt();
        }
    }
}
