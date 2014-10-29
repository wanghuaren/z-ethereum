package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *向world请求加入pk活动
    */
    public class PacketCWJoinPk implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20043;
        /** 
        *camp 数值2 3
        */
        public var camp:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(camp);
        }
        public function Deserialize(ar:ByteArray):void
        {
            camp = ar.readInt();
        }
    }
}
