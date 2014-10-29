package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *存钱到仓库
    */
    public class PacketCSBankStoreMoney implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8022;
        /** 
        *数量
        */
        public var money:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(money);
        }
        public function Deserialize(ar:ByteArray):void
        {
            money = ar.readInt();
        }
    }
}
