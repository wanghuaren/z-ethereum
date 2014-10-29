package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *角色登陆返回
    */
    public class PacketGCRoleLogin implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 104;
        /** 
        *登陆结果
        */
        public var tag:int;
        /** 
        *登陆的账号
        */
        public var accountid:int;
        /** 
        *返回消息
        */
        public var msg:String = new String();
        /** 
        *同步时间
        */
        public var servertime:Number;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(accountid);
            PacketFactory.Instance.WriteString(ar, msg, 400);
            ar.writeDouble(servertime);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            accountid = ar.readInt();
            var msgLength:int = ar.readInt();
            msg = ar.readMultiByte(msgLength,PacketFactory.Instance.GetCharSet());
            servertime = ar.readDouble();
        }
    }
}
