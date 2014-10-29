package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *自动扣钱使用物品
    */
    public class PacketCSUseItemAutoBuy implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 24701;
        /** 
        *物品编号
        */
        public var itemid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(itemid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            itemid = ar.readInt();
        }
    }
}
