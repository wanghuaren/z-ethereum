package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *参加公会结盟
    */
    public class PacketCSGuildAllyIn implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 39253;
        /** 
        *参加类型,0表示普通参加,1表示召唤参加
        */
        public var flag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(flag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            flag = ar.readInt();
        }
    }
}
