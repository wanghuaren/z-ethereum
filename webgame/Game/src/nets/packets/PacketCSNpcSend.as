package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *NPC传送列表
    */
    public class PacketCSNpcSend implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 13009;
        /** 
        *
        */
        public var list_id:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(list_id);
        }
        public function Deserialize(ar:ByteArray):void
        {
            list_id = ar.readInt();
        }
    }
}
