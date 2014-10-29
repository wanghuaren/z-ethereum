package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *激活剑灵
    */
    public class PacketCSActiveBlade implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 12105;
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
