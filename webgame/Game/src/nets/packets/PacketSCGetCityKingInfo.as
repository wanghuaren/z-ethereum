package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *膜拜城主信息返回
    */
    public class PacketSCGetCityKingInfo implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 53204;
        /** 
        *膜拜剩余时间
        */
        public var left_time:int;
        /** 
        *膜拜持续总时间
        */
        public var time:int;
        /** 
        *膜拜所得经验
        */
        public var exp:int;
        /** 
        *0 结束膜拜， 1 正在膜拜
        */
        public var state:int;
        /** 
        *错误码
        */
        public var tag:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(left_time);
            ar.writeInt(time);
            ar.writeInt(exp);
            ar.writeInt(state);
            ar.writeInt(tag);
        }
        public function Deserialize(ar:ByteArray):void
        {
            left_time = ar.readInt();
            time = ar.readInt();
            exp = ar.readInt();
            state = ar.readInt();
            tag = ar.readInt();
        }
    }
}
