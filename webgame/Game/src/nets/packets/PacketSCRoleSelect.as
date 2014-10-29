package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *游戏服务器通知玩家已初始化好选择的角色数据
    */
    public class PacketSCRoleSelect implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 118;
        /** 
        *结果
        */
        public var tag:int;
        /** 
        *提示
        */
        public var msg:String = new String();
        /** 
        *角色
        */
        public var userid:int;
        /** 
        *名字
        */
        public var rolename:String = new String();
        /** 
        *登录次数
        */
        public var logintimes:int;
        /** 
        *地图
        */
        public var mapid:int;
        /** 
        *地图X
        */
        public var mapx:int;
        /** 
        *地图Y
        */
        public var mapy:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, msg, 128);
            ar.writeInt(userid);
            PacketFactory.Instance.WriteString(ar, rolename, 32);
            ar.writeInt(logintimes);
            ar.writeInt(mapid);
            ar.writeInt(mapx);
            ar.writeInt(mapy);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
            userid = ar.readInt();
            var rolenameLength:int = ar.readInt();
            rolename = ar.readMultiByte(rolenameLength,PacketFactory.Instance.GetCharSet());
            logintimes = ar.readInt();
            mapid = ar.readInt();
            mapx = ar.readInt();
            mapy = ar.readInt();
        }
    }
}
