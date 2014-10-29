package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *活动得分日志
    */
    public class StructActCharRecInfo implements ISerializable
    {
        /** 
        *角色id
        */
        public var roleid:int;
        /** 
        *角色名称
        */
        public var rolename:String = new String();
        /** 
        *得分
        */
        public var point:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(roleid);
            PacketFactory.Instance.WriteString(ar, rolename, 128);
            ar.writeInt(point);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            var rolenameLength:int = ar.readInt();
            rolename = ar.readMultiByte(rolenameLength,PacketFactory.Instance.GetCharSet());
            point = ar.readInt();
        }
    }
}
