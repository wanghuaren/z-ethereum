package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *队友是否同意报名参赛
    */
    public class PacketCSAgreeSignSH implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 52906;
        /** 
        *是否同意报名，0:不同意；1：同意
        */
        public var agree:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(agree);
        }
        public function Deserialize(ar:ByteArray):void
        {
            agree = ar.readInt();
        }
    }
}
