package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *请求刷新全国押运结果
    */
    public class PacketCSRefleshNationBeautyResult implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 54710;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
        }
        public function Deserialize(ar:ByteArray):void
        {
        }
    }
}
