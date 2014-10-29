package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *领取累计签到奖励
    */
    public class PacketCSContinueAward implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 37009;
        /** 
        *1:累计7天 2 累计14 3累计21 4累计28
        */
        public var type:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(type);
        }
        public function Deserialize(ar:ByteArray):void
        {
            type = ar.readInt();
        }
    }
}
