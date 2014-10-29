package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取镇魔谷奖励
    */
    public class PacketCSDevilGetPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 55203;
        /** 
        *倍数
        */
        public var multiple:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(multiple);
        }
        public function Deserialize(ar:ByteArray):void
        {
            multiple = ar.readInt();
        }
    }
}
