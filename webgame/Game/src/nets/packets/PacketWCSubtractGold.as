package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *减去金券
    */
    public class PacketWCSubtractGold implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 197;
        /** 
        *减去金券的数量
        */
        public var gold:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(gold);
        }
        public function Deserialize(ar:ByteArray):void
        {
            gold = ar.readInt();
        }
    }
}
