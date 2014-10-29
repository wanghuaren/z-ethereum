package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *卖物品
    */
    public class PacketCSItemSell implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 17003;
        /** 
        *物品位置
        */
        public var pos:int;
        /** 
        *数量
        */
        public var num:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(pos);
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            pos = ar.readInt();
            num = ar.readInt();
        }
    }
}
