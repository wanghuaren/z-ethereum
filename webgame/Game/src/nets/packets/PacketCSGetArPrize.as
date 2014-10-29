package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取成就奖励
    */
    public class PacketCSGetArPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24006;
        /** 
        *成就编号,0领取所有
        */
        public var arid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(arid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            arid = ar.readInt();
        }
    }
}
