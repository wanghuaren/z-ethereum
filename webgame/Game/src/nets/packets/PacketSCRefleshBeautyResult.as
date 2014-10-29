package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *请求刷新美人结果
    */
    public class PacketSCRefleshBeautyResult implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39918;
        /** 
        *美人id
        */
        public var beauty:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(beauty);
        }
        public function Deserialize(ar:ByteArray):void
        {
            beauty = ar.readInt();
        }
    }
}
