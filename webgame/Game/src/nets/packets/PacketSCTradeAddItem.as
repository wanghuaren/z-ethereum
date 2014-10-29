package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *添加物品结果
    */
    public class PacketSCTradeAddItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8658;
        /** 
        *结果
        */
        public var tag:int;
        /** 
        *位置
        */
        public var pos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(pos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            pos = ar.readInt();
        }
    }
}
