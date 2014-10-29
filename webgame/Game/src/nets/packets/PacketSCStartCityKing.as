package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *膜拜城主返回
    */
    public class PacketSCStartCityKing implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53202;
        /** 
        *0 结束膜拜， 1 开始膜拜
        */
        public var flag:int;
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(flag);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            flag = ar.readInt();
            tag = ar.readInt();
        }
    }
}
