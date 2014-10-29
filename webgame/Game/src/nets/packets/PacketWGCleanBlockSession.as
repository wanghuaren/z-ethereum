package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *清理网关上玩家卡住的链接
    */
    public class PacketWGCleanBlockSession implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 205;
        /** 
        *账号ID
        */
        public var accountId:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(accountId);
        }
        public function Deserialize(ar:ByteArray):void
        {
            accountId = ar.readInt();
        }
    }
}
