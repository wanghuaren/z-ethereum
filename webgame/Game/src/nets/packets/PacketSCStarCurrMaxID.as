package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *当前境界
    */
    public class PacketSCStarCurrMaxID implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 27007;
        /** 
        *境界编号
        */
        public var star_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(star_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            star_id = ar.readInt();
        }
    }
}
