package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *阵营排行榜玩家数据
    */
    public class StructCampPlayerRankInfo implements ISerializable
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
        *阵营
        */
        public var camp:int;
        /** 
        *积分
        */
        public var point:int;
        /** 
        *vip
        */
        public var para1:int;
        /** 
        *等级
        */
        public var para2:int;
        /** 
        *预留
        */
        public var para3:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(roleID);
            PacketFactory.Instance.WriteString(ar, rolename, 32);
            ar.writeInt(camp);
            ar.writeInt(point);
            ar.writeInt(para1);
            ar.writeInt(para2);
            ar.writeInt(para3);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleID = ar.readInt();
            var rolenameLength:int = ar.readInt();
            rolename = ar.readMultiByte(rolenameLength,PacketFactory.Instance.GetCharSet());
            camp = ar.readInt();
            point = ar.readInt();
            para1 = ar.readInt();
            para2 = ar.readInt();
            para3 = ar.readInt();
        }
    }
}
