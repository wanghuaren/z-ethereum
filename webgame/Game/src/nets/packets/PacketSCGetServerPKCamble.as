package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获得玩家押注返回
    */
    public class PacketSCGetServerPKCamble implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 40010;
        /** 
        *押注玩家编号
        */
        public var no:int;
        /** 
        *押注玩家编号 0 代表未押注
        */
        public var gamble_no:int;
        /** 
        *押注阶段
        */
        public var step:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(no);
            ar.writeInt(gamble_no);
            ar.writeInt(step);
        }
        public function Deserialize(ar:ByteArray):void
        {
            no = ar.readInt();
            gamble_no = ar.readInt();
            step = ar.readInt();
        }
    }
}
