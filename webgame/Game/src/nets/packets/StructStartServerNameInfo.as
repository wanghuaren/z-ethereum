package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *开服嘉年华详细信息
    */
    public class StructStartServerNameInfo implements ISerializable
    {
        /** 
        *职业
        */
        public var metier:int;
        /** 
        *名称
        */
        public var name:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(metier);
            PacketFactory.Instance.WriteString(ar, name, 32);
        }
        public function Deserialize(ar:ByteArray):void
        {
            metier = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
