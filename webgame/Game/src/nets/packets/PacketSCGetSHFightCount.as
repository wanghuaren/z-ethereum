package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得个人赛比赛次数返回
    */
    public class PacketSCGetSHFightCount implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53021;
        /** 
        *次数
        */
        public var num:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            num = ar.readInt();
        }
    }
}
