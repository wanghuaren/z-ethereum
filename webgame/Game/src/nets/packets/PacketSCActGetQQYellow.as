package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取QQ黄钻续费活动信息返回
    */
    public class PacketSCActGetQQYellow implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38130;
        /** 
        *QQ黄钻续费活动开始日期,格式20120101
        */
        public var begin_date:int;
        /** 
        *QQ黄钻续费活动结束日期
        */
        public var end_date:int;
        /** 
        *QQ黄钻续费活动活动状态
        */
        public var state:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            ar.writeInt(begin_date);
            ar.writeInt(end_date);
            ar.writeInt(state);
        }
        public function Deserialize(ar:ByteArray):void
        {
            begin_date = ar.readInt();
            end_date = ar.readInt();
            state = ar.readInt();
        }
    }
}
