package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家警告通知
    */
    public class PacketSCAlert implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 998;
        /** 
        *玩家警告通知类型(1为3小时内每小时通知，2为3小时满通知，3为4-5小时通知，4为5-6小时通知)
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
        }
    }
}
