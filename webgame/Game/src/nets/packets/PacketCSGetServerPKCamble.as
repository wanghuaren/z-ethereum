package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得玩家押注情况
    */
    public class PacketCSGetServerPKCamble implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 40009;
        /** 
        *押注玩家编号
        */
        public var no:int;
        /** 
        *押注阶段
        */
        public var step:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(no);
            ar.writeInt(step);
        }
        public function Deserialize(ar:ByteArray):void
        {
            no = ar.readInt();
            step = ar.readInt();
        }
    }
}
