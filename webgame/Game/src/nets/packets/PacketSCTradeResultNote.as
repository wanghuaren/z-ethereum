package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *交易结果通知
    */
    public class PacketSCTradeResultNote implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 8666;
        /** 
        *结果
        */
        public var tag:int;
        /** 
        *结果:1成功，2取消
        */
        public var result:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(tag);
            ar.writeInt(result);
        }
        public function Deserialize(ar:ByteArray):void
        {
            tag = ar.readInt();
            result = ar.readInt();
        }
    }
}
