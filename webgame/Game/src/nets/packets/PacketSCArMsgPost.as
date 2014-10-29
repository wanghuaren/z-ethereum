package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *成就信息通知
    */
    public class PacketSCArMsgPost implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24005;
        /** 
        *信息对应的tag
        */
        public var tag:int;
        /** 
        *玩家名称
        */
        public var pname:String = new String();

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            PacketFactory.Instance.WriteString(ar, pname, 32);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            var pnameLength:int = ar.readInt();
            pname = ar.readMultiByte(pnameLength,PacketFactory.Instance.GetCharSet());
        }
    }
}
