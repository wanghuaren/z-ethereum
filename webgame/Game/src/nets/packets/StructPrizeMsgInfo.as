package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *奖励消息数据
    */
    public class StructPrizeMsgInfo implements ISerializable
    {
        /** 
        *奖励序号
        */
        public var sn:int;
        /** 
        *奖励信息
        */
        public var tag:int;
        /** 
        *奖励信息
        */
        public var msg:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(sn);
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 256);
        }
        public function Deserialize(ar:ByteArray):void
        {
            sn = ar.readInt();
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
