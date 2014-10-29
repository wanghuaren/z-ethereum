package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *查询是否可以领取工会领地争夺1
    */
    public class PacketCSGetGuildArea1PrizeInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 52204;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
        }
        public function Deserialize(ar:ByteArray):void
        {
        }
    }
}
