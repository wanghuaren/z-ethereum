package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *回调字符型参数列表
    */
    public class StructCharParamList implements ISerializable
    {
        /** 
        *字符型参数
        */
        public var charparam:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            PacketFactory.Instance.WriteString(ar, charparam, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var charparamLength:int = ar.readInt();
            charparam = ar.readMultiByte(charparamLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
