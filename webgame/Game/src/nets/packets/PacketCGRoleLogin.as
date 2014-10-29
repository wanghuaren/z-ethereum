package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *角色登陆
    */
    public class PacketCGRoleLogin implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 103;
        /** 
        *用户名
        */
        public var username:String = new String();
        /** 
        *密码
        */
        public var password:String = new String();
        /** 
        *登陆
        */
        public var login_time:String = new String();
        /** 
        *登陆来源
        */
        public var login_state:String = new String();
        /** 
        *服务器
        */
        public var server:String = new String();
        /** 
        *登陆标记
        */
        public var sign:String = new String();
        /** 
        *
        */
        public var p_id:String = new String();
        /** 
        *是否防沉迷
        */
        public var isfcm:int;
        /** 
        *ip
        */
        public var userip:String = new String();
        /** 
        *qq黄钻vip
        */
        public var qqyellowvip:String = new String();
        /** 
        *登录类型,1为微端,其他为普通登录
        */
        public var login_type:int;
        /** 
        *邀请人id
        */
        public var parent_id:String = new String();
        /** 
        *自定义数据
        */
        public var custom_param:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            PacketFactory.Instance.WriteString(ar, username, 32);
            PacketFactory.Instance.WriteString(ar, password, 128);
            PacketFactory.Instance.WriteString(ar, login_time, 32);
            PacketFactory.Instance.WriteString(ar, login_state, 32);
            PacketFactory.Instance.WriteString(ar, server, 32);
            PacketFactory.Instance.WriteString(ar, sign, 120);
            PacketFactory.Instance.WriteString(ar, p_id, 32);
            ar.writeInt(isfcm);
            PacketFactory.Instance.WriteString(ar, userip, 32);
            PacketFactory.Instance.WriteString(ar, qqyellowvip, 32);
            ar.writeInt(login_type);
            PacketFactory.Instance.WriteString(ar, parent_id, 120);
            PacketFactory.Instance.WriteString(ar, custom_param, 512);
        }
        public function Deserialize(ar:ByteArray):void
        {
            var usernameLength:int = ar.readInt();
            username = ar.readMultiByte(usernameLength,PacketFactory.Instance.GetCharSet());
            var passwordLength:int = ar.readInt();
            password = ar.readMultiByte(passwordLength,PacketFactory.Instance.GetCharSet());
            var login_timeLength:int = ar.readInt();
            login_time = ar.readMultiByte(login_timeLength,PacketFactory.Instance.GetCharSet());
            var login_stateLength:int = ar.readInt();
            login_state = ar.readMultiByte(login_stateLength,PacketFactory.Instance.GetCharSet());
            var serverLength:int = ar.readInt();
            server = ar.readMultiByte(serverLength,PacketFactory.Instance.GetCharSet());
            var signLength:int = ar.readInt();
            sign = ar.readMultiByte(signLength,PacketFactory.Instance.GetCharSet());
            var p_idLength:int = ar.readInt();
            p_id = ar.readMultiByte(p_idLength,PacketFactory.Instance.GetCharSet());
            isfcm = ar.readInt();
            var useripLength:int = ar.readInt();
            userip = ar.readMultiByte(useripLength,PacketFactory.Instance.GetCharSet());
            var qqyellowvipLength:int = ar.readInt();
            qqyellowvip = ar.readMultiByte(qqyellowvipLength,PacketFactory.Instance.GetCharSet());
            login_type = ar.readInt();
            var parent_idLength:int = ar.readInt();
            parent_id = ar.readMultiByte(parent_idLength,PacketFactory.Instance.GetCharSet());
            var custom_paramLength:int = ar.readInt();
            custom_param = ar.readMultiByte(custom_paramLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
