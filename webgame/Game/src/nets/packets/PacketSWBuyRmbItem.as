package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *买东西
    */
    public class PacketSWBuyRmbItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 32009;
        /** 
        *物品
        */
        public var item:int;
        /** 
        *数量
        */
        public var num:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(item);
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            item = ar.readInt();
            num = ar.readInt();
        }
    }
}
