package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取西游降魔宝箱
    */
    public class PacketCSGetXiYouMonsterPrize implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38125;
        /** 
        *宝箱序号
        */
        public var num:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            num = ar.readInt();
        }
    }
}
