package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *NPC喊话
    */
    public class PacketSCNpcShout implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 7007;
        /** 
        *对象id
        */
        public var objid:int;
        /** 
        *喊话id
        */
        public var shoutid:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(objid);
            ar.writeInt(shoutid);
        }
        public function Deserialize(ar:ByteArray):void
        {
            objid = ar.readInt();
            shoutid = ar.readInt();
        }
    }
}
