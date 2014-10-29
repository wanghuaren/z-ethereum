package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *申请交易通知
    */
    public class PacketSCTradeRequestNote implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8653;
        /** 
        *结果
        */
        public var tag:int;
        /** 
        *邀请者
        */
        public var roleid:int;
        /** 
        *邀请者名称
        */
        public var king_name:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(roleid);
            PacketFactory.Instance.WriteString(ar, king_name, 256);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            roleid = ar.readInt();
            var king_nameLength:int = ar.readInt();
            king_name = ar.readMultiByte(king_nameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
