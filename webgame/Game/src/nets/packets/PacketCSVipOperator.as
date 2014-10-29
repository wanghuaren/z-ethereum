package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *VIP操作
    */
    public class PacketCSVipOperator implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31012;
        /** 
        *操作代码
        */
        public var opcode:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(opcode);
        }
        public function Deserialize(ar:ByteArray):void
        {
            opcode = ar.readInt();
        }
    }
}
