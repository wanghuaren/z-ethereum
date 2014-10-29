package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *聊天对象的基本信息
    */
    public class PacketWCSayRoleInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 10091;
        /** 
        *角色ID
        */
        public var roleid:int;
        /** 
        *角色ID
        */
        public var name:String = new String();
        /** 
        *头像
        */
        public var headicon:int;
        /** 
        *签名
        */
        public var underwrite:int;
        /** 
        *签名参数1
        */
        public var underwrite_p1:int;
        /** 
        *签名参数2
        */
        public var underwrite_p2:int;
        /** 
        *VIP
        */
        public var vip:int;
        /** 
        *qq黄钻等级
        */
        public var qqyellowvip:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleid);
            PacketFactory.Instance.WriteString(ar, name, 64);
            ar.writeInt(headicon);
            ar.writeInt(underwrite);
            ar.writeInt(underwrite_p1);
            ar.writeInt(underwrite_p2);
            ar.writeInt(vip);
            ar.writeInt(qqyellowvip);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            headicon = ar.readInt();
            underwrite = ar.readInt();
            underwrite_p1 = ar.readInt();
            underwrite_p2 = ar.readInt();
            vip = ar.readInt();
            qqyellowvip = ar.readInt();
        }
    }
}
