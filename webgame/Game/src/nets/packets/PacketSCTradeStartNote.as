package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *交易开始通知
    */
    public class PacketSCTradeStartNote implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8656;
        /** 
        *对方ID
        */
        public var roleid:int;
        /** 
        *对方名称
        */
        public var king_name:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(roleid);
            PacketFactory.Instance.WriteString(ar, king_name, 256);
        }
        public function Deserialize(ar:ByteArray):void
        {
            roleid = ar.readInt();
            var king_nameLength:int = ar.readInt();
            king_name = ar.readMultiByte(king_nameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
