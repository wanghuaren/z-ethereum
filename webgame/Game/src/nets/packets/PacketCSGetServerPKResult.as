package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得玩家比赛结果
    */
    public class PacketCSGetServerPKResult implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 40011;
        /** 
        *玩家编号
        */
        public var no:int;
        /** 
        *阶段
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
