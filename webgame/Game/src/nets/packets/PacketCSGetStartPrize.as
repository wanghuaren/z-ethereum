package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取开服礼包
    */
    public class PacketCSGetStartPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31107;
        /** 
        *获取礼包ID,为1,2,3
        */
        public var packid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(packid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            packid = ar.readInt();
        }
    }
}
