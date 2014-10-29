package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *副本排行榜数据
    */
    public class PacketCSInstanceRank implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 29028;
        /** 
        *副本标识,1表示四神器1,2表示四神器2,3表示四神器3,4表示四神器4,5表示魔天万界
        */
        public var instanceid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(instanceid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            instanceid = ar.readInt();
        }
    }
}
