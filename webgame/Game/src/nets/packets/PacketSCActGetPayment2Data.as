package nets.packets
{
    import flash.utils.ByteArray;
    import engine.support.ISerializable;
    import engine.support.IPacket;
    import engine.net.packet.PacketFactory;
    import netc.packets2.StructActCharRecInfoList2
    /** 
    *获取充值活动数据返回
    */
    public class PacketSCActGetPayment2Data implements IPacket
    {
        /**
        *id
        */
        public static const id:int = 38112;
        /** 
        *榜内容
        */
        public var cur:StructActCharRecInfoList2 = new StructActCharRecInfoList2();
        /** 
        *充值活动开始日期,格式20120101
        */
        public var begin_date:int;
        /** 
        *充值活动结束日期
        */
        public var end_date:int;
        /** 
        *自己充值数量
        */
        public var num:int;
        /** 
        *需要充值数量
        */
        public var basenum:int;

        public function GetId():int{return id;}
        public function Serialize(ar:ByteArray):void
        {
            ar.writeInt(GetId());
            cur.Serialize(ar);
            ar.writeInt(begin_date);
            ar.writeInt(end_date);
            ar.writeInt(num);
            ar.writeInt(basenum);
        }
        public function Deserialize(ar:ByteArray):void
        {
            cur.Deserialize(ar);
            begin_date = ar.readInt();
            end_date = ar.readInt();
            num = ar.readInt();
            basenum = ar.readInt();
        }
    }
}
