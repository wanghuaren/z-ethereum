package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *仙道会总排名用户信息
    */
    public class StructServerPKRankUserInfo implements ISerializable
    {
        /** 
        *用户accountid
        */
        public var accountid:int;
        /** 
        *职业
        */
        public var metier:int;
        /** 
        *排名信息
        */
        public var no:int;
        /** 
        *名称
        */
        public var name:String = new String();
        /** 
        *s0
        */
        public var s0:int;
        /** 
        *s1
        */
        public var s1:int;
        /** 
        *s2
        */
        public var s2:int;
        /** 
        *s3
        */
        public var s3:int;
        /** 
        *r1
        */
        public var r1:int;
        /** 
        *头像
        */
        public var icon:int;
        /** 
        *黄钻
        */
        public var qqyellowvip:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(accountid);
            ar.writeInt(metier);
            ar.writeInt(no);
            PacketFactory.Instance.WriteString(ar, name, 64);
            ar.writeInt(s0);
            ar.writeInt(s1);
            ar.writeInt(s2);
            ar.writeInt(s3);
            ar.writeInt(r1);
            ar.writeInt(icon);
            ar.writeInt(qqyellowvip);
        }
        public function Deserialize(ar:ByteArray):void
        {
            accountid = ar.readInt();
            metier = ar.readInt();
            no = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            s0 = ar.readInt();
            s1 = ar.readInt();
            s2 = ar.readInt();
            s3 = ar.readInt();
            r1 = ar.readInt();
            icon = ar.readInt();
            qqyellowvip = ar.readInt();
        }
    }
}
