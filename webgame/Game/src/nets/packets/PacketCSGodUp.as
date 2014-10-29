package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *神兵升级
    */
    public class PacketCSGodUp implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 55101;
        /** 
        *是否使用元宝100%成功
        */
        public var isCoin3:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(isCoin3);
        }
        public function Deserialize(ar:ByteArray):void
        {
            isCoin3 = ar.readInt();
        }
    }
}
