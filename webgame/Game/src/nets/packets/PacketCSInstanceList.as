package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *副本报名信息列表
    */
    public class PacketCSInstanceList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 20003;
        /** 
        *副本组id
        */
        public var groupid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(groupid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            groupid = ar.readInt();
        }
    }
}
