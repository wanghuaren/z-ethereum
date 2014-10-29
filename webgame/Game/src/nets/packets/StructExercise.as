package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *修炼数据
    */
    public class StructExercise implements ISerializable
    {
        /** 
        * 0 没有在修炼， 1在修炼
        */
        public var isexercise:int;
        /** 
        *开始修炼时间高位
        */
        public var starthightime:int;
        /** 
        *开始修炼时间低位
        */
        public var startlowtime:int;
        /** 
        *离线时间高位
        */
        public var offlinehightime:int;
        /** 
        *离线时间低位
        */
        public var offlinelowtime:int;
        /** 
        *坐骑的位置
        */
        public var curhoursepose:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(isexercise);
            ar.writeInt(starthightime);
            ar.writeInt(startlowtime);
            ar.writeInt(offlinehightime);
            ar.writeInt(offlinelowtime);
            ar.writeInt(curhoursepose);
        }
        public function Deserialize(ar:ByteArray):void
        {
            isexercise = ar.readInt();
            starthightime = ar.readInt();
            startlowtime = ar.readInt();
            offlinehightime = ar.readInt();
            offlinelowtime = ar.readInt();
            curhoursepose = ar.readInt();
        }
    }
}
