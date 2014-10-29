package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *珍宝阁查询
    */
    public class PacketCSTreasureShopQuery implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 51500;
        /** 
        *所属标签
        */
        public var type:int;
        /** 
        *所属标签本地版本
        */
        public var ver:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
            ar.writeInt(ver);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
            ver = ar.readInt();
        }
    }
}
