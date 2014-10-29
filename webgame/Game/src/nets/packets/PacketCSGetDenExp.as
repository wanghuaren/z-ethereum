package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *领取始皇魔窟经验
    */
    public class PacketCSGetDenExp implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29203;
        /** 
        *倍数：1,2,3,4,5
        */
        public var multiple:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(multiple);
        }
        public function Deserialize(ar:ByteArray):void
        {
            multiple = ar.readInt();
        }
    }
}
