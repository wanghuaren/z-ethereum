package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *宠物栏
    */
    public class StructPetSlot implements ISerializable
    {
        /** 
        *是否开启
        */
        public var slotstate:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeByte(slotstate);
        }
        public function Deserialize(ar:ByteArray):void
        {
            slotstate = ar.readByte();
        }
    }
}
