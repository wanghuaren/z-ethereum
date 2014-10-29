package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *SH比赛信息
    */
    public class StructSHFightUserInfo implements ISerializable
    {
        /** 
        *用户accountid
        */
        public var accountid:int;
        /** 
        *图标
        */
        public var icon:int;
        /** 
        *血量百分比
        */
        public var per:int;
        /** 
        *名称
        */
        public var name:String = new String();
        /** 
        *是否死亡过
        */
        public var isdead:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(accountid);
            ar.writeInt(icon);
            ar.writeInt(per);
            PacketFactory.Instance.WriteString(ar, name, 64);
            ar.writeInt(isdead);
        }
        public function Deserialize(ar:ByteArray):void
        {
            accountid = ar.readInt();
            icon = ar.readInt();
            per = ar.readInt();
            var nameLength:int = ar.readInt();
            name = ar.readMultiByte(nameLength,PacketFactory.Instance.GetCharSet());
            isdead = ar.readInt();
        }
    }
}
