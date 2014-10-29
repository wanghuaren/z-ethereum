package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *请求刷新全国押运结果
    */
    public class PacketSCRefleshNationBeautyResult implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54711;
        /** 
        *全国押运id
        */
        public var beauty:int;
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(beauty);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            beauty = ar.readInt();
            tag = ar.readInt();
        }
    }
}
