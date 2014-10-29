package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *标记操作
    */
    public class PacketCSSpecialFlagAct implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 31019;
        /** 
        *操作代码,1表示桌面快捷方式奖励
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
