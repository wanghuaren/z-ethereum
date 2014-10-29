package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *NPC功能
    */
    public class StructNpcFunc implements ISerializable
    {
        /** 
        *ID
        */
        public var talk_id:int;
        /** 
        *序号
        */
        public var index:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(talk_id);
            ar.writeInt(index);
        }
        public function Deserialize(ar:ByteArray):void
        {
            talk_id = ar.readInt();
            index = ar.readInt();
        }
    }
}
