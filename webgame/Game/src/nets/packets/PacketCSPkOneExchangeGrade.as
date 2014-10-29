package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *pk之王兑换积分
    */
    public class PacketCSPkOneExchangeGrade implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 51300;
        /** 
        *兑换 0:10个 1:50个 2:100个
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            flag = ar.readInt();
        }
    }
}
