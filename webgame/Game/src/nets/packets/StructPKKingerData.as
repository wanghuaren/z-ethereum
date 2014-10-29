package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *pk之王信息
    */
    public class StructPKKingerData implements ISerializable
    {
        /** 
        *id
        */
        public var userid:int;
        /** 
        *名称
        */
        public var name:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(userid);
            PacketFactory.Instance.WriteString(ar, name, 32);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
