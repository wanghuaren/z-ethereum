package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *活动积分
    */
    public class StructActPlayerPoint implements ISerializable
    {
        /** 
        *活动id
        */
        public var actid:int;
        /** 
        *玩家积分
        */
        public var point:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(actid);
            ar.writeInt(point);
        }
        public function Deserialize(ar:ByteArray):void
        {
            actid = ar.readInt();
            point = ar.readInt();
        }
    }
}
