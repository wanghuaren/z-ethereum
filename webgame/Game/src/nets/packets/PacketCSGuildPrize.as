package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取公会礼包
    */
    public class PacketCSGuildPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39247;
        /** 
        *获取礼包，1-5依次是等级礼包
        */
        public var prize:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(prize);
        }
        public function Deserialize(ar:ByteArray):void
        {
            prize = ar.readInt();
        }
    }
}
