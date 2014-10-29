package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *玩家副本数据
    */
    public class StructPlayerInstanceInfo implements ISerializable
    {
        /** 
        *副本id
        */
        public var instanceid:int;
        /** 
        *当前次数
        */
        public var curnum:int;
        /** 
        *最大次数
        */
        public var maxnum:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(instanceid);
            ar.writeInt(curnum);
            ar.writeInt(maxnum);
        }
        public function Deserialize(ar:ByteArray):void
        {
            instanceid = ar.readInt();
            curnum = ar.readInt();
            maxnum = ar.readInt();
        }
    }
}
