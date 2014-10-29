package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *修改报名方式
    */
    public class PacketCSModifySignSH implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53012;
        /** 
        *参与类型 低位第1位 单人匹配 低位第2位 2人匹配 低位第3位 3人匹配
        */
        public var join_type:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(join_type);
        }
        public function Deserialize(ar:ByteArray):void
        {
            join_type = ar.readInt();
        }
    }
}
