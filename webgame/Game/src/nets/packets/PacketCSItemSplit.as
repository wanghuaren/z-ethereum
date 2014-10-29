package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *拆分物品
    */
    public class PacketCSItemSplit implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8028;
        /** 
        *位置
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
