package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *膜拜城主
    */
    public class PacketCSStartCityKing implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53201;
        /** 
        *0 结束膜拜， 1 开始膜拜
        */
        public var flag:int;
        /** 
        *0 膜拜时间，单位分钟(与function单位保持一致)
        */
        public var time:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(flag);
            ar.writeInt(time);
        }
        public function Deserialize(ar:ByteArray):void
        {
            flag = ar.readInt();
            time = ar.readInt();
        }
    }
}
