package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *服务器列表
    */
    public class PacketCGServerList implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 101;
        /** 
        *用户ID
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
