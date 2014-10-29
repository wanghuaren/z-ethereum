package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *信息提示参数
    */
    public class StructMsgParam implements ISerializable
    {
        /** 
        *参数类型
        */
        public var ptype:int;
        /** 
        *参数整数值
        */
        public var intvalue:int;
        /** 
        *参数字符串值
        */
        public var strvalue:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(ptype);
            ar.writeInt(intvalue);
            PacketFactory.Instance.WriteString(ar, strvalue, 256);
        }
        public function Deserialize(ar:ByteArray):void
        {
            ptype = ar.readInt();
            intvalue = ar.readInt();
            var strvalueLength:int = ar.readInt();
            strvalue = ar.readMultiByte(strvalueLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
