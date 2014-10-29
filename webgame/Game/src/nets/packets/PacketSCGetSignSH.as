package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *报名状态返回
    */
    public class PacketSCGetSignSH implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 52905;
        /** 
        *是否已经报名，0 未报名， 1 已经报名
        */
        public var sign:int;
        /** 
        *结果
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(sign);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            sign = ar.readInt();
            tag = ar.readInt();
        }
    }
}
