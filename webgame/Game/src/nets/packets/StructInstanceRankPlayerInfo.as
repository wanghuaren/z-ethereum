package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *副本排行榜数据
    */
    public class StructInstanceRankPlayerInfo implements ISerializable
    {
        /** 
        *角色ID
        */
        public var roleID:int;
        /** 
        *角色名字
        */
        public var rolename:String = new String();
        /** 
        *副本数据1
        */
        public var para1:int;
        /** 
        *副本数据2
        */
        public var para2:int;
        /** 
        *副本数据3
        */
        public var para3:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(roleID);
            PacketFactory.Instance.WriteString(ar, rolename, 32);
            ar.writeInt(para1);
            ar.writeInt(para2);
            ar.writeInt(para3);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleID = ar.readInt();
            var rolenameLength:int = ar.readInt();
            rolename = ar.readMultiByte(rolenameLength,PacketFactory.Instance.GetCharSet());
            para1 = ar.readInt();
            para2 = ar.readInt();
            para3 = ar.readInt();
        }
    }
}
