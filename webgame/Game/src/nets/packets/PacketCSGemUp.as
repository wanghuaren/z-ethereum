package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *装备宝石
    */
    public class PacketCSGemUp implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54203;
        /** 
        *宝石在背包里面的位置
        */
        public var gempos:int;
        /** 
        *目标位置：0自动判断
        */
        public var targetpos:int;
        /** 
        *洞的位置：0自动判断
        */
        public var holepos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(gempos);
            ar.writeInt(targetpos);
            ar.writeInt(holepos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            gempos = ar.readInt();
            targetpos = ar.readInt();
            holepos = ar.readInt();
        }
    }
}
