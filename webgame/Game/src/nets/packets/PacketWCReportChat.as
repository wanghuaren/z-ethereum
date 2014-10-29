package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *举报玩家
    */
    public class PacketWCReportChat implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 195;
        /** 
        *举报玩家
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
