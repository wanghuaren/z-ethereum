package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *设置用户可以修改名称
    */
    public class PacketSWSetUserCanRename implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 198;
        /** 
        *userid
        */
        public var userid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(userid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
        }
    }
}
