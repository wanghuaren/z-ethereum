package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *观星数据
    */
    public class StructStarWatchData implements ISerializable
    {
        /** 
        *点亮次数
        */
        public var lightNum:int;
        /** 
        *box状态
        */
        public var starBoxState:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(lightNum);
            ar.writeInt(starBoxState);
        }
        public function Deserialize(ar:ByteArray):void
        {
            lightNum = ar.readInt();
            starBoxState = ar.readInt();
        }
    }
}
