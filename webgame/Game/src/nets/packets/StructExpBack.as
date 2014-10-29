package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.net.packet.PacketFactory;
    /** 
    *经验找回
    */
    public class StructExpBack implements ISerializable
    {
        /** 
        *活动组id
        */
        public var actionid:int;
        /** 
        *0今天1昨天2前天3大前天
        */
        public var day:int;
        /** 
        *  0.不可以领取【今天活动未做】1.昨天已经参与或者完成【不显示】2.可以领取【今天活动完成】3.已经领取
        */
        public var state:int;

        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(actionid);
            ar.writeInt(day);
            ar.writeInt(state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            actionid = ar.readInt();
            day = ar.readInt();
            state = ar.readInt();
        }
    }
}
