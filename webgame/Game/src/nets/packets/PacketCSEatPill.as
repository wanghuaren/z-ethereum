package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *吃丹药
    */
    public class PacketCSEatPill implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 27000;
        /** 
        *物品id
        */
        public var toolid:int;
        /** 
        *境界位置
        */
        public var pos:int;
        /** 
        *是否元宝代替
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(toolid);
            ar.writeInt(pos);
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            toolid = ar.readInt();
            pos = ar.readInt();
            flag = ar.readInt();
        }
    }
}
