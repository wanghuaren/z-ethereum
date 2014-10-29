package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    /** 
    *获取寻宝活动信息返回
    */
    public class PacketSCActGetDiscoveringTreasure implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38153;
        /** 
        *寻宝活动开始日期,格式20120101
        */
        public var begin_date:int;
        /** 
        *寻宝活动结束日期
        */
        public var end_date:int;
        /** 
        *寻宝活动状态
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
