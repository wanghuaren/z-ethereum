package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *摆摊留言记录
    */
    public class StructBoothLeaveWord implements ISerializable
    {
        /** 
        *时间
        */
        public var time:int;
        /** 
        *留言内容
        */
        public var leave_word:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(time);
            PacketFactory.Instance.WriteString(ar, leave_word, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            time = ar.readInt();
            var leave_wordLength:int = ar.readInt();
            leave_word = ar.readMultiByte(leave_wordLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
