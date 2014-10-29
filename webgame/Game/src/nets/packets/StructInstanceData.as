package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *副本信息
    */
    public class StructInstanceData implements ISerializable
    {
        /** 
        *组id
        */
        public var groupid:int;
        /** 
        *进入次数
        */
        public var num:int;
        /** 
        *当前高位key
        */
        public var cur_key_hi:int;
        /** 
        *当前低位key
        */
        public var cur_key_low:int;
        /** 
        *上次高位key
        */
        public var b_key_hi:int;
        /** 
        *上次低位key
        */
        public var b_key_low:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(groupid);
            ar.writeInt(num);
            ar.writeInt(cur_key_hi);
            ar.writeInt(cur_key_low);
            ar.writeInt(b_key_hi);
            ar.writeInt(b_key_low);
        }
        public function Deserialize(ar:ByteArray):void
        {
            groupid = ar.readInt();
            num = ar.readInt();
            cur_key_hi = ar.readInt();
            cur_key_low = ar.readInt();
            b_key_hi = ar.readInt();
            b_key_low = ar.readInt();
        }
    }
}
