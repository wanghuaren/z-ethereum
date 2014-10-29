package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *全服抽奖史册
    */
    public class PacketCSSignInLog implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 37011;
        /** 
        *缓存版本号
        */
        public var version:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(version);
        }
        public function Deserialize(ar:ByteArray):void
        {
            version = ar.readInt();
        }
    }
}
