package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *奖励信息
    */
    public class StructPrizeInfo implements ISerializable
    {
        /** 
        *道具id
        */
        public var toolid:int;
        /** 
        *道具数量
        */
        public var toolnum:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(toolid);
            ar.writeInt(toolnum);
        }
        public function Deserialize(ar:ByteArray):void
        {
            toolid = ar.readInt();
            toolnum = ar.readInt();
        }
    }
}
