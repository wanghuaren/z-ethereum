package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *御剑飞行
    */
    public class PacketSCFly implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39919;
        /** 
        *1表示开始飞行，0表示停止飞行
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            flag = ar.readInt();
        }
    }
}
