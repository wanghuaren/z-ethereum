package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *向world请求加入pk 当前阵营返回
    */
    public class PacketWCGetPkCamp implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20087;
        /** 
        *camp 数值 0 没有阵营 2 3
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
