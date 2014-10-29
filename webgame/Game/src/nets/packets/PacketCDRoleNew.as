package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *创建角色
    */
    public class PacketCDRoleNew implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 110;
        /** 
        *账号ID
        */
        public var accountID:int;
        /** 
        *名字
        */
        public var rolename:String = new String();
        /** 
        *性别
        */
        public var sex:int;
        /** 
        *头像
        */
        public var icon:int;
        /** 
        *职业
        */
        public var metier:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(accountID);
            PacketFactory.Instance.WriteString(ar, rolename, 50);
            ar.writeInt(sex);
            ar.writeInt(icon);
            ar.writeInt(metier);
        }
        public function Deserialize(ar:ByteArray):void
        {
            accountID = ar.readInt();
            var rolenameLength:int = ar.readInt();
            rolename = ar.readMultiByte(rolenameLength,PacketFactory.Instance.GetCharSet());
            sex = ar.readInt();
            icon = ar.readInt();
            metier = ar.readInt();
        }
    }
}
