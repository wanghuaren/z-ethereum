package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *已经获得的但未领取的在线礼包
    */
    public class StructOnlinePrizeData implements ISerializable
    {
        /** 
        *奖励Dropid
        */
        public var drop_id:int;
        /** 
        *数量
        */
        public var num:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(drop_id);
            ar.writeInt(num);
        }
        public function Deserialize(ar:ByteArray):void
        {
            drop_id = ar.readInt();
            num = ar.readInt();
        }
    }
}
