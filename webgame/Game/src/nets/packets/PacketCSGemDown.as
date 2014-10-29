package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *卸下宝石
    */
    public class PacketCSGemDown implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54205;
        /** 
        *宝石的位置
        */
        public var gempos:int;
        /** 
        *洞的位置：0自动判断
        */
        public var holepos:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(gempos);
            ar.writeInt(holepos);
        }
        public function Deserialize(ar:ByteArray):void
        {
            gempos = ar.readInt();
            holepos = ar.readInt();
        }
    }
}
