package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *怪物场景喊话
    */
    public class PacketSCMonsterSayMap implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 10089;
        /** 
        *id
        */
        public var monsterid:int;
        /** 
        *喊话id
        */
        public var shoutid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(monsterid);
            ar.writeInt(shoutid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            monsterid = ar.readInt();
            shoutid = ar.readInt();
        }
    }
}
