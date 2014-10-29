package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *QQ黄钻续费礼包日志
    */
    public class StructQQYellowLog implements ISerializable
    {
        /** 
        *留言内容
        */
        public var msg:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            PacketFactory.Instance.WriteString(ar, msg, 256);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
