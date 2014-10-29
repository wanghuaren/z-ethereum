package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *上架物品
    */
    public class PacketCSBoothAddItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8606;
        /** 
        *物品位置
        */
        public var pos:int;
        /** 
        *出售价格
        */
        public var price:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pos);
            ar.writeInt(price);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readInt();
            price = ar.readInt();
        }
    }
}
