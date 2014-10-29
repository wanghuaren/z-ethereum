package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *宠物喊话时间和类型
    */
    public class StructPetShoutData implements ISerializable
    {
        /** 
        *喊话开始时间
        */
        public var begintime:int;
        /** 
        *类型
        */
        public var sort:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(begintime);
            ar.writeInt(sort);
        }
        public function Deserialize(ar:ByteArray):void
        {
            begintime = ar.readInt();
            sort = ar.readInt();
        }
    }
}
