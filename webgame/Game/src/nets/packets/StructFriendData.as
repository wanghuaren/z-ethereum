package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *好友列表
    */
    public class StructFriendData implements ISerializable
    {
        /** 
        *角色ID
        */
        public var roleid:int;
        /** 
        *角色名字
        */
        public var rolename:String = new String();
        /** 
        *角色职业
        */
        public var job:int;
        /** 
        *角色等级
        */
        public var level:int;
        /** 
        *角色在线状态
        */
        public var online:int;
        /** 
        *类型（好友，仇人，黑名单）
        */
        public var type:int;
        /** 
        *角色vip
        */
        public var vip:int;
        /** 
        *QQ黄钻vip
        */
        public var qqyellowvip:int;
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
        *阵营
        */
        public var camp:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(roleid);
            PacketFactory.Instance.WriteString(ar, rolename, 64);
            ar.writeInt(job);
            ar.writeInt(level);
            ar.writeInt(online);
            ar.writeInt(type);
            ar.writeInt(vip);
            ar.writeInt(qqyellowvip);
            ar.writeInt(underwrite);
            ar.writeInt(underwrite_p1);
            ar.writeInt(underwrite_p2);
            ar.writeInt(headicon);
            ar.writeInt(camp);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            var rolenameLength:int = ar.readInt();
            rolename = ar.readMultiByte(rolenameLength,PacketFactory.Instance.GetCharSet());
            job = ar.readInt();
            level = ar.readInt();
            online = ar.readInt();
            type = ar.readInt();
            vip = ar.readInt();
            qqyellowvip = ar.readInt();
            underwrite = ar.readInt();
            underwrite_p1 = ar.readInt();
            underwrite_p2 = ar.readInt();
            headicon = ar.readInt();
            camp = ar.readInt();
        }
    }
}
