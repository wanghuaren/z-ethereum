package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *召唤剑灵
    */
    public class PacketCSCallBlade implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 12103;
        /** 
        *剑灵编号
        */
        public var npc_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(npc_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            npc_id = ar.readInt();
        }
    }
}
