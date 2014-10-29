package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *寻宝积分兑换
    */
    public class PacketCSMineGradeExchange implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 15051;
        /** 
        *合成ID
        */
        public var makeid:int;
        /** 
        *物品位置 不需要的话填0
        */
        public var pos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(makeid);
            ar.writeInt(pos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            makeid = ar.readInt();
            pos = ar.readInt();
        }
    }
}
