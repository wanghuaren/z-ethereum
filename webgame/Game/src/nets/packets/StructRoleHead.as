package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *角色头像
    */
    public class StructRoleHead implements ISerializable
    {
        /** 
        *头像编号
        */
        public var id:int;
        /** 
        *头像路径
        */
        public var path:String = new String();

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(id);
            PacketFactory.Instance.WriteString(ar, path, 128);
        }
        public function Deserialize(ar:ByteArray):void
        {
            id = ar.readInt();
            var pathLength:int = ar.readInt();
            path = ar.readMultiByte(pathLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
