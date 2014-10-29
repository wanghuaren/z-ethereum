package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *开服嘉年华第一幻境信息
    */
    public class StructStartServerEnvInfo implements ISerializable
    {
        /** 
        *人
        */
        public var userid:int;
        /** 
        *天
        */
        public var day:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(userid);
            ar.writeInt(day);
        }
        public function Deserialize(ar:ByteArray):void
        {
            userid = ar.readInt();
            day = ar.readInt();
        }
    }
}
