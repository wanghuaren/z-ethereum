package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *任务自动传送
    */
    public class PacketCSAutoSend implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 13012;
        /** 
        *寻路编号
        */
        public var seekid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(seekid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            seekid = ar.readInt();
        }
    }
}
