package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *仙道会比赛信息
    */
    public class StructServerPKMatchInfo implements ISerializable
    {
        /** 
        *比赛界数
        */
        public var no:int;
        /** 
        *比赛时间
        */
        public var time:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(no);
            ar.writeInt(time);
        }
        public function Deserialize(ar:ByteArray):void
        {
            no = ar.readInt();
            time = ar.readInt();
        }
    }
}
