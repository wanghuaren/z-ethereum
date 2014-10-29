package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家在线时间变动
    */
    public class PacketWSCPlayerOLMinuteChange implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 207;
        /** 
        *总在线时间(分钟)
        */
        public var ol_minute:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(ol_minute);
        }
        public function Deserialize(ar:ByteArray):void
        {
            ol_minute = ar.readInt();
        }
    }
}
