package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *物品移动
    */
    public class PacketCSMoveItem implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8008;
        /** 
        *源位置
        */
        public var srcindex:int;
        /** 
        *目的位置
        */
        public var destindex:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(srcindex);
            ar.writeInt(destindex);
        }
        public function Deserialize(ar:ByteArray):void
        {
            srcindex = ar.readInt();
            destindex = ar.readInt();
        }
    }
}
