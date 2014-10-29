package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *坐骑升星石合成
    */
    public class PacketCSHorseStarStoneCompose implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 16031;
        /** 
        *强化石id
        */
        public var ItemId:int;
        /** 
        *合成数量
        */
        public var Count:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(ItemId);
            ar.writeInt(Count);
        }
        public function Deserialize(ar:ByteArray):void
        {
            ItemId = ar.readInt();
            Count = ar.readInt();
        }
    }
}
