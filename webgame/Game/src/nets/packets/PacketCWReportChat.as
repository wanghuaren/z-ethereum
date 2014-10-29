package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *举报玩家
    */
    public class PacketCWReportChat implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 194;
        /** 
        *举报者的roleid
        */
        public var targetid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(targetid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            targetid = ar.readInt();
        }
    }
}
