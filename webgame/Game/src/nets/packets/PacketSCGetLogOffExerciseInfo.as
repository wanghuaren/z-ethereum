package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取离线修炼信息返回
    */
    public class PacketSCGetLogOffExerciseInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 23207;
        /** 
        *修炼总时间,单位秒
        */
        public var time:int;
        /** 
        *修炼单倍经验
        */
        public var exp:int;
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(time);
            ar.writeInt(exp);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            time = ar.readInt();
            exp = ar.readInt();
            tag = ar.readInt();
        }
    }
}
