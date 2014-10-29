package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取新的卡片
    */
    public class PacketSCNewCard implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38003;
        /** 
        *新的卡片ID
        */
        public var card:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(card);
        }
        public function Deserialize(ar:ByteArray):void
        {
            card = ar.readInt();
        }
    }
}
