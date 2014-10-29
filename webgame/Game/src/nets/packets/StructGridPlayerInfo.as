package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *角色信息
    */
    public class StructGridPlayerInfo implements ISerializable
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
        *职业
        */
        public var metier:int;
        /** 
        *等级
        */
        public var level:int;
        /** 
        *队伍id
        */
        public var teamid:int;
        /** 
        *系统签名
        */
        public var underwrite:int;
        /** 
        *
        */
        public var underwrite_p1:int;
        /** 
        *
        */
        public var underwrite_p2:int;
        /** 
        *头像
        */
        public var headicon:int;
        /** 
        *vip
        */
        public var vip:int;
        /** 
        *qq yellow vip
        */
        public var qqyellowvip:int;
        /** 
        *阵营
        */
        public var camp:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(roleID);
            PacketFactory.Instance.WriteString(ar, rolename, 32);
            ar.writeInt(metier);
            ar.writeInt(level);
            ar.writeInt(teamid);
            ar.writeInt(underwrite);
            ar.writeInt(underwrite_p1);
            ar.writeInt(underwrite_p2);
            ar.writeInt(headicon);
            ar.writeInt(vip);
            ar.writeInt(qqyellowvip);
            ar.writeInt(camp);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleID = ar.readInt();
            var rolenameLength:int = ar.readInt();
            rolename = ar.readMultiByte(rolenameLength,PacketFactory.Instance.GetCharSet());
            metier = ar.readInt();
            level = ar.readInt();
            teamid = ar.readInt();
            underwrite = ar.readInt();
            underwrite_p1 = ar.readInt();
            underwrite_p2 = ar.readInt();
            headicon = ar.readInt();
            vip = ar.readInt();
            qqyellowvip = ar.readInt();
            camp = ar.readInt();
        }
    }
}
